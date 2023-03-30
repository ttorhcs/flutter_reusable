import 'package:flutter/material.dart';
import 'package:flutter_reusable/containers/labeled_outline_container.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;

import '../FormatHelpers.dart';
import 'date_picker.dart';


class PopupDateField extends FormField<DateTime> {
  final String label;
  final FormFieldValidator<DateTime> validator;
  final DateTime Function() dateValue;
  final DateTime Function() minDateValue;
  final DateTime Function() maxDateValue;
  final Function(DateTime) onChanged;

  PopupDateField(this.label, this.validator, this.dateValue,this.onChanged,{this.minDateValue,this.maxDateValue,  Key key})
      : super(
            key: key,
            builder: (FormFieldState<DateTime> field) {
              final PopupDateFieldState state = field as PopupDateFieldState;
              return state.build(field.context);
            },
            validator: validator,
            onSaved: onChanged);

  @override
  PopupDateFieldState createState() => PopupDateFieldState();
}

class PopupDateFieldState extends FormFieldState<DateTime> {
  @override
  PopupDateField get widget => super.widget as PopupDateField;

  @override
  void setValue(DateTime value) {
    super.setValue(value);
  }

  @override
  Widget build(BuildContext context) {
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
              return Stack(children: [
                Positioned(
                  top: y,
                  left: x,
                  child: LabeledOutlineContainer(
                    error: this.hasError ? this.errorText : null,
                    label: widget.label,
                    color: Colors.white,
                    width: width,
                    child: dp.DayPicker.single(
                      selectedDate: widget.dateValue(),
                      onChanged: (value) {
                        widget.onChanged(value);
                        Navigator.of(context).pop();
                      },
                      datePickerStyles: dp.DatePickerRangeStyles(),
                      firstDate: widget?.minDateValue?.call() == null ? DateTime.now().subtract(Duration(days: 3650)) : widget.minDateValue(),
                      lastDate: widget?.maxDateValue?.call() == null ? DateTime.now().add(Duration(days: 3650)): widget.maxDateValue(),
                    ),
                  ),
                ),
              ]);
            },
          );
          setState(() {});
          //periodPickerKey.currentState.setPeriod(DatePeriod(fromUtcMilSecToLocalDt(_innerDto?.startTime), fromUtcMilSecToLocalDt(_innerDto?.endTime)));
        },
        child: LabeledOutlineContainer(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
          label: widget.label,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(child: Text(FormatHelpers.formatDate(widget.dateValue == null ? null : widget.dateValue()))),
              Icon(Icons.edit),
            ],
          ),
        ),
      ),
    );
  }
}

class DateSelectorPopup extends StatefulWidget {
  final double x;
  final double y;
  final double width;
  final DateTime Function() value;
  final Function(DateTime) onChanged;

  const DateSelectorPopup(this.x, this.y, this.width, this.value, this.onChanged, {Key key}) : super(key: key);

  @override
  DateSelectorPopupState createState() => DateSelectorPopupState();
}

class DateSelectorPopupState extends State<DateSelectorPopup> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: widget.y,
          left: widget.x,
          child: Material(
            child: LabeledOutlineContainer(
              width: widget.width,
              label: "Dátum",
              child: Center(
                  child: Column(
                children: [
                  DatePickerWidget(widget.value(), (date) {
                    widget.onChanged(date);
                    Navigator.of(context).pop();
                  }),
                ],
              )),
            ),
          ),
        ),
      ],
    );
  }
}
