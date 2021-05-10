import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class InputFormatters {
  //allows only numbers and max 23:59
  static TextInputFormatter hourMin() {
    return MaskedTextInputFormatter(
      mask: "00:00",
      separator: ":",
      pattern: RegExp(r'\d+'),
      filterFunction: (val) {
        if(val != null && val.length > 0){
          List max = [2, 9, 5, 9];
          for (int i = 0; i < val.length; i++) {
            int current = int.tryParse(val[i]);
            if (max[i] < current) {
              return false;
            }
          }
          if(val.length < 3){
            int hours = int.tryParse(val);
            if(hours > 23){
              return false;
            }
          }
          if(val.length < 4){
            int hoursMin = int.tryParse(val);
            if(hoursMin > 235){
              return false;
            }
          }
          int hoursMinMin = int.tryParse(val);
          if(hoursMinMin > 2359){

          }
        }
        return true;
      },
    );
  }

  static TextInputFormatter masked(String mask, String separator) {
    return MaskedTextInputFormatter(mask: mask, separator: separator);
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  final Pattern pattern;
  final Function(String) filterFunction;

  MaskedTextInputFormatter({
    @required this.mask,
    @required this.separator,
    this.pattern,
    this.filterFunction,
  }) {
    assert(mask != null);
    assert(separator != null);
  }

  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.length > 0) {
      debugPrint("${oldValue.text} ${newValue.text}");
      if (newValue.text.length > oldValue.text.length) {
        if (pattern != null) {
          String withoutSeparator = newValue.text.replaceAll(separator, "");
          String filteredfWithPrefix = withoutSeparator.replaceAll(pattern, "");
          if (filteredfWithPrefix.length != 0) {
            return oldValue;
          }
          if (!filterFunction(withoutSeparator)) {
            return oldValue;
          }
        }
        if (newValue.text.length > mask.length) {
          return oldValue;
        }
        if (newValue.text.length < mask.length && mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text: '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

class DecimalTextInputFormatter extends TextInputFormatter {
  DecimalTextInputFormatter({this.decimalRange})
      : assert(decimalRange == null || decimalRange > 0);

  final int decimalRange;

  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue,
      TextEditingValue newValue,
      ) {
    bool accept = true;
    if(newValue.text.isNotEmpty) {
      if (double.tryParse(newValue.text) == null) {
        accept = false;
      }
      String _val = newValue.text.replaceAll(",", ".");
      var decimals = _val.split(".");
      if (decimals.length == 2 && decimals[1].length > decimalRange) {
        accept = false;
      }
    }

    return accept ? newValue : oldValue;
  }
}
