import 'package:flutter/material.dart';
import 'package:flutter_reusable/components/widget_builder.dart';

class CheckboxWidget extends StatefulWidget {
  final String label;
  final String tooltip;
  final bool value;
  final Function(bool) changedListener;

  CheckboxWidget(this.label, this.value, this.changedListener, {this.tooltip});

  @override
  _CheckboxWidgetState createState() => _CheckboxWidgetState();
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  setValue(bool val) {
    if (val != null) {
      value = val;
    } else {
      value = false;
    }
    setState(() {});
  }

  bool value = false;
  bool changed = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!changed) {
      setValue(widget.value);
    }
    changed = false;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Tooltip(
          child: text(widget.label),
          message: widget.tooltip ?? "",
        ),
        Checkbox(
          activeColor: Colors.black54,
          value: value,
          onChanged: (value) {
            widget.changedListener(value);
            changed = true;
            setState(() {
              this.value = value;
            });
          },
        ),
      ],
    );
  }
}
