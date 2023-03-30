import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart';

class DatePeriodPicker extends StatefulWidget {

  final DatePeriod period;
  final Function(DatePeriod) onChanged;

  DatePeriodPicker(this.period, this.onChanged, {key}): super(key: key);

  @override
  DatePeriodPickerState createState() => DatePeriodPickerState();
}

class DatePeriodPickerState extends State<DatePeriodPicker> {

  DatePeriod currentPeriod;

  bool changed = false;


  @override
  Widget build(BuildContext context) {
    if(!changed){
      DateTime from = widget.period?.start ?? DateTime.now();
      DateTime to = widget.period?.end ?? DateTime.now();
      currentPeriod = DatePeriod(from,to);
    }
    changed = false;

    return RangePicker(
      datePickerLayoutSettings: DatePickerLayoutSettings(

      ),
      selectedPeriod: currentPeriod,
      onChanged: (value) {
          currentPeriod = value;
          changed = true;
        setState(() {
        });
        if(currentPeriod.start != null && currentPeriod.end != null) {
          widget.onChanged(currentPeriod);
        }
      },
      firstDate:
      DateTime.now().subtract(Duration(days: 3650)),
      lastDate: DateTime.now().add(Duration(days: 3650)),
    ); //ints
  }
}
