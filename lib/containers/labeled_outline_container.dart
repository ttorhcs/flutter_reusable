import 'package:flutter/material.dart';

class LabeledOutlineContainer extends StatefulWidget {
  final Widget child;
  final String label;
  final bool labelBold;
  final double height;
  final double width;
  final Color color;
  final String error;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final bool shadow;
  final bool disabledColor;

  LabeledOutlineContainer(
      {this.child,
      this.label,
      this.labelBold = false,
      this.height,
      this.width,
      this.color,
      this.error,
      this.margin,
      this.padding,
      this.shadow = false,
      this.disabledColor = false});

  @override
  LabeledOutlineContainerState createState() => LabeledOutlineContainerState();
}

class LabeledOutlineContainerState extends State<LabeledOutlineContainer> {
  String errorMsg = "";

  Color _color;

  @override
  Widget build(BuildContext context) {
    if (null == widget.color) {
      _color = Colors.transparent;
    } else {
      _color = widget.color;
    }

    if (widget.error != null) {
      errorMsg = widget.error;
    } else {
      errorMsg = "";
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 800),
      height: widget.height,
      width: widget.width,
      margin: widget.margin == null ? EdgeInsets.all(0) : widget.margin,
      padding: EdgeInsets.all(0),
      child: Stack(
        children: [
          Container(
            margin: EdgeInsets.fromLTRB(1, 8, 1, 2),
            padding: widget.padding != null ? widget.padding : EdgeInsets.symmetric(horizontal: 5, vertical: 0),
            decoration: BoxDecoration(
              border: Border.all(color: errorMsg == "" ? Colors.black26 : Colors.red, width: 1),
              borderRadius: BorderRadius.circular(5),
              color: widget.disabledColor ? Color.alphaBlend(Colors.black.withAlpha(5), _color) : _color,
              boxShadow: widget.shadow ? getShadows() : [],
            ),
            child: widget.child,
          ),
          Container(
            color: widget.color == null ? Colors.transparent : widget.color,
            margin: EdgeInsets.fromLTRB(10, 1, 0, 0),
            padding: EdgeInsets.only(left: 5, right: 5),
            child: Text(
              widget.label ?? "",
              style: TextStyle(
                backgroundColor: widget.color == null ? Theme.of(context).canvasColor : widget.color,
                fontWeight: widget.labelBold ? FontWeight.bold : null
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            left: 0,
            child: Container(
              color: Colors.transparent,
              child: Center(
                child: Text(
                  errorMsg,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    backgroundColor: errorMsg.isEmpty
                        ? Colors.transparent
                        : widget.color == null
                            ? Colors.transparent
                            : widget.color,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  setError(String errorMsg) {
    if (null == errorMsg) {
      errorMsg = "";
    }
    setState(() {
      this.errorMsg = errorMsg;
    });
  }

  getShadows() {
    List<BoxShadow> rtn = List.empty(growable: true);
    rtn.add(BoxShadow(
      color: Colors.black38,
      offset: Offset(0, 5),
      blurRadius: 10,
    ));

    return rtn;
  }
}
