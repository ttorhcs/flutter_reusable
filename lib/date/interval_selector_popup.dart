import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

import '../FormatHelpers.dart';
import '../containers/labeled_outline_container.dart';
import '../components/widget_builder.dart';
import 'date_period_picker.dart';

class IntervalSelectorPopup extends StatefulWidget {
  final DatePeriod Function() getValue;
  final Function(DatePeriod) setValue;

  const IntervalSelectorPopup({@required this.getValue,@required this.setValue, Key key}) : super(key: key);

  @override
  IntervalSelectorPopupState createState() => IntervalSelectorPopupState();
}

class IntervalSelectorPopupState extends State<IntervalSelectorPopup> {
  GlobalKey _intervalKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    DatePeriod period = widget.getValue();
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () async {
          FocusScope.of(context).unfocus();
          RenderBox box = context.findRenderObject() as RenderBox;
          Offset position = box.localToGlobal(Offset.zero); //this is global position
          double y = position.dy;
          double x = position.dx;
          double width = box.constraints.maxWidth;
          bool res = await showDialog(
            barrierColor: Colors.transparent,
            barrierDismissible: true,
            context: context,
            builder: (context) {
              return IntervalPopupContent(x,y,width, ()=>period, (val)=> period = val);
            },
          );
          widget.setValue(period);
          setState(() {});
          //periodPickerKey.currentState.setPeriod(DatePeriod(fromUtcMilSecToLocalDt(_innerDto?.startTime), fromUtcMilSecToLocalDt(_innerDto?.endTime)));
        },
        child: LabeledOutlineContainer(
          label: "Intervallum",
          child: Column(
            key: _intervalKey,
            children: [
              Expanded(
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      FormatHelpers.formatDateTime(widget.getValue().start),
                    ),
                    Text(" - "),
                    Text(
                      FormatHelpers.formatDateTime(widget.getValue().end),
                    ),
                    Icon(
                      Icons.edit,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class IntervalPopupContent extends StatefulWidget {
  final double x;
  final double y;
  final double width;
  final DatePeriod Function() getValue;
  final Function(DatePeriod) setValue;

  const IntervalPopupContent(this.x, this.y, this.width, this.getValue,this.setValue, {Key key}) : super(key: key);

  @override
  _IntervalPopupContentState createState() => _IntervalPopupContentState();
}

class _IntervalPopupContentState extends State<IntervalPopupContent> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          left: widget.x,
          top: widget.y,
          child: Material(
            child: LabeledOutlineContainer(
              width: widget.width,
              label: "Intervallum",
              child: Center(
                  child: Column(
                    children: [
                      DatePeriodPicker(widget.getValue(), (period) {
                        widget.setValue(period);
                        setState(() {});
                      }),
                      fieldSpacing(),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          text(FormatHelpers.formatDate(widget.getValue().start), bold: true),
                          text(" - ", bold: true),
                          text(FormatHelpers.formatDate(widget.getValue().end), bold: true),
                        ],
                      ),
                      fieldSpacing(),
                    ],
                  )),
            ),
          ),
        ),
      ],
    );
  }
}
