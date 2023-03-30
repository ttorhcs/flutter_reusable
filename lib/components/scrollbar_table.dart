import 'package:flutter/material.dart';

import 'widget_builder.dart';

class ScrollBarTable extends StatefulWidget {
  final List<double> columnWidths;
  final List<Widget> header;
  final IndexedWidgetBuilder indexedRowBuilder;
  final List<Widget> Function(int) listRowBuilder;
  final int numOfItems;
  final Function(int) rowClicked;
  final int Function() selectedIndex;
  final Color selectedColor;
  final bool separated;
  final FocusNode focusNode;

  ScrollBarTable(
      {this.columnWidths,
        @required this.header,
        this.indexedRowBuilder,
        this.listRowBuilder,
        @required this.numOfItems,
        this.rowClicked,
        this.selectedIndex,
        this.selectedColor: Colors.black12,
        this.separated: false,
      this.focusNode : null});

  @override
  _ScrollBarTableState createState() => _ScrollBarTableState();
}

class _ScrollBarTableState extends State<ScrollBarTable> {
  ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (widget.numOfItems > 0 && _scrollController.offset == 0) {
        _scrollController.animateTo(1, duration: Duration(milliseconds: 100), curve: Curves.ease);
      }
    });
    return Column(
      children: [
        _buildRow(widget.header),
        widget.header != null ? dividerH() : Container(),
        Expanded(
          child: Scrollbar(
            isAlwaysShown: true,
            controller: _scrollController,
            child: ListView.separated(
              separatorBuilder: (context, index) {
                return widget.separated ? dividerH() : Container();
              },
              itemCount: widget.numOfItems,
              controller: _scrollController,
              itemBuilder: (context, index) {
                Widget rtn;
                if (null != widget.indexedRowBuilder) {
                  rtn = widget.indexedRowBuilder(context, index);
                } else {
                  rtn = _buildRow(widget.listRowBuilder(index));
                }
                if (widget.rowClicked != null) {
                  rtn = GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    child: rtn,
                    onTap: () {
                      widget.rowClicked(index);
                      setState(() {});
                    },
                  );
                }
                Color color;
                if (widget.selectedIndex != null && index == widget.selectedIndex()) {
                  color = widget.selectedColor;
                }
                return Container(
                  padding: EdgeInsets.symmetric(horizontal: 0, vertical: 5),
                  color: color,
                  child: rtn,
                );
                ;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRow(List<Widget> content) {
    if (null == content) {
      return Container();
    }

    int columnNum = widget.columnWidths?.length ?? 0;
    if (content.length > columnNum) {
      columnNum = content.length;
    }

    List<Widget> cells = [];
    for (int i = 0; i < columnNum; i++) {
      Widget w = Container();
      if (content.length > i) {
        w = content[i];
      }

      double width = 0;
      if (widget.columnWidths != null && widget.columnWidths.length > i) {
        width = widget.columnWidths[i];
      }

      cells.add(_buildColumn(width, w));
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: cells,
    );
  }

  _buildColumn(double width, Widget w) {
    if (width == null || width <= 0) {
      return Expanded(child: w);
    } else {
      return Container(
        width: width,
        child: w,
      );
    }
  }
}
