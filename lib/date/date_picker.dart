import 'package:flutter/material.dart';
import 'package:flutter_date_pickers/flutter_date_pickers.dart' as dp;
import 'package:flutter_reusable/components/widget_builder.dart';

import '../FormatHelpers.dart';
import '../containers/fade_indexed_stack.dart';
class DatePickerWidget extends StatefulWidget {
  final DateTime date;
  final Function(DateTime) onChanged;
  final bool daysAddButtons;

  DatePickerWidget(this.date, this.onChanged, {this.daysAddButtons = false});

  @override
  DatePickerWidgetState createState() => DatePickerWidgetState();
}

class DatePickerWidgetState extends State<DatePickerWidget> {
  DateTime _currentDate;

  bool changed = false;
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    if (!changed) {
      _currentDate = widget.date ?? DateTime.now();
    }
    changed = false;

    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      height: _index == 1 ? 300 : 50,
      child: FadeIndexedStack(
        index: _index,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                FormatHelpers.formatDate(_currentDate),
                style: TextStyle(fontSize: 20),
              ),
              getDaysButtons(),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () {
                  changed = true;
                  _index = 1;
                  setState(() {});
                },
              ),
            ],
          ),
          dp.DayPicker.single(
            selectedDate: _currentDate,
            onChanged: (value) {
              changed = true;
              _currentDate = value;
              widget.onChanged(_currentDate);
              _index = 0;

              setState(() {});
            },
            datePickerStyles: dp.DatePickerRangeStyles(),
            firstDate: DateTime.now().subtract(Duration(days: 3650)),
            lastDate: DateTime.now().add(Duration(days: 3650)),
          ),
        ],
      ),
    ); //ints
  }

  getDaysButtons() {
    if (!widget.daysAddButtons) {
      return Container();
    } else {
      return Row(
        children: [
          InkWell(
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text("+8\nnap"),
            ),
            onTap: () {
              _currentDate = _currentDate.add(Duration(days: 8));
              widget.onChanged(_currentDate);
              changed = true;
              setState(() {});
            },
          ),
          fieldSpacing(),
          InkWell(
            child: Container(
              padding: EdgeInsets.all(3),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
                borderRadius: BorderRadius.circular(3),
              ),
              child: Text("+15\nnap"),
            ),
            onTap: () {
              _currentDate = _currentDate.add(Duration(days: 15));
              widget.onChanged(_currentDate);
              changed = true;
              setState(() {});
            },
          ),

        ],
      );
    }
  }
}
