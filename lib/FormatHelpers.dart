import 'package:intl/intl.dart';

class FormatHelpers{

  static DateFormat _dateFormatter = DateFormat("yyyy.MM.dd");
  /// yyyy.MM.dd
  static String formatDate(DateTime dateTime){
    if(null != dateTime) {
      return _dateFormatter.format(dateTime);
    }
    return "";
  }
  /// yyyy.MM.dd HH:mm
  static DateFormat _dateTimeFormatter = DateFormat("yyyy.MM.dd HH:mm");
  static String formatDateTime(DateTime dateTime){
    if(null != dateTime) {
      return _dateTimeFormatter.format(dateTime);
    }
    return "";
  }

    static NumberFormat _formatter = NumberFormat(",##0", "hu");
  static String formatNumber(num num){
    return _formatter.format(num);
  }


  static NumberFormat _formatterDecimal = NumberFormat(",##0.00", "hu");
  static String formatNumberDecimal(num num){
    return _formatterDecimal.format(num);
  }


}