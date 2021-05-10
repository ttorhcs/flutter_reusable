import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_reusable/InputFormatters.dart';
import 'package:flutter_reusable/StringUtils.dart';
import 'package:flutter_reusable/components/checkbox.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

///Returns new [TextFormField]
///Optional [TextInputType] default is String
///If [TextWidgetInputType] is numeric a Numerical keyboard given
TextFormField textFormTextWidget(String label, dynamic value, Function(dynamic) onChanged, Function(String) validator,
    {TextWidgetInputType inputType,
    FocusNode focus,
    TextInputFormatter inputFormatter,
    TextEditingController controller,
    String hintText = "",
    passwordField = false,
    bool enabled = true,
    bool startWithFocus = false,
    Function(String) onFieldSubmitted}) {
  List<TextInputFormatter> inputFormatters = List.empty(growable: true);
  if (null != inputFormatter) {
    inputFormatters.add(inputFormatter);
    List<TextInputFormatter> others = getFormatters(inputType);
    if (others != null) {
      inputFormatters.addAll(others);
    }
  }
  int lines = 1;
  int minLines = 1;
  switch (inputType) {
    case TextWidgetInputType.LINES2:
      lines = 2;
      break;
    case TextWidgetInputType.LINES3:
      lines = 3;
      break;
    case TextWidgetInputType.LINES4:
      lines = 4;
      break;
    case TextWidgetInputType.LINES5:
      lines = 5;
      break;
    case TextWidgetInputType.LINES_5_FIX:
      lines = 5;
      minLines = 5;
      break;
  }

  return TextFormField(
    enabled: enabled,
    focusNode: focus,
    minLines: minLines,
    maxLines: lines,
    autofocus: startWithFocus,
    controller: controller != null ? controller : TextEditingController()
      ..value = TextEditingValue(text: (value != null ? "$value" : ""), selection: TextSelection.collapsed(offset: (value != null ? "$value".length : 0))),
    decoration: InputDecoration(
      labelText: label,
      hintText: hintText,
    ),
    onChanged: (value) {
      var rtn;
      if (inputType == TextWidgetInputType.INT) {
        rtn = int.tryParse(value) ?? 0;
        onChanged(rtn);
        return;
      }
      if (inputType == TextWidgetInputType.DOUBLE) {
        rtn = double.tryParse(value) ?? 0;
        onChanged(rtn);
        return;
      }
      rtn ??= value;
      onChanged(rtn);
    },
    validator: (_) => validator != null ? validator(_) : null,
    inputFormatters: inputFormatters,
    keyboardType: getKeyboardType(inputType),
    obscureText: passwordField,
    onFieldSubmitted: onFieldSubmitted,
  );
}

enum TextWidgetInputType { INT, DOUBLE, STRING, LINES2, LINES3, LINES4, LINES5, LINES_5_FIX }

List<TextInputFormatter> getFormatters(TextWidgetInputType inputType) {
  List<TextInputFormatter> rtn;
  if (inputType == TextWidgetInputType.INT) {
    rtn = List.empty(growable: true)..add(FilteringTextInputFormatter.digitsOnly);
  }
  if (inputType == TextWidgetInputType.DOUBLE) {
    rtn = List.empty(growable: true)..add(DecimalTextInputFormatter(decimalRange: 2));
  }
  return rtn;
}

TextInputType getKeyboardType(TextWidgetInputType inputType) {
  if (inputType == TextWidgetInputType.INT) {
    return TextInputType.number;
  }
  if (inputType == TextWidgetInputType.DOUBLE) {
    return TextInputType.number;
  }
  return null;
}

SizedBox fieldSpacing({double sizeHV = 5}) {
  return SizedBox(
    width: sizeHV,
    height: sizeHV,
  );
}

Future<bool> showYesNoAlert(
    BuildContext context,
    String title,
    String desc,
    String okTitle,
    String noTitle,
    ) async {
  List<DialogButton> buttons = List.empty(growable: true)
    ..add(DialogButton(
      color: Colors.black.withOpacity(0.1),
      child: Text(okTitle),
      onPressed: () => Navigator.of(context).pop(true),
    ))
    ..add(DialogButton(
      color: Colors.black26.withOpacity(0.1),
      child: Text(noTitle),
      onPressed: () => Navigator.of(context).pop(false),
    ));
  return Alert(context: context, title: title, desc: desc, buttons: buttons).show();
}

Future<bool> showAlert(
    BuildContext context,
    String title,
    Widget content,
    String okTitle,
    ) async {
  List<DialogButton> buttons = List.empty(growable: true)
    ..add(DialogButton(
      color: Colors.black.withOpacity(0.1),
      child: Text(okTitle),
      onPressed: () => Navigator.of(context).pop(true),
    ));
  return Alert(style: AlertStyle(overlayColor: Colors.black12), context: context, title: title, content: content, buttons: buttons, closeFunction: () => true)
      .show();
}

showErrorAlert(
    BuildContext context,
    String title,
    String desc,
    ) {
  List<DialogButton> buttons = []
    ..add(DialogButton(
      color: Colors.black.withOpacity(0.1),
      child: Text("Hiba másolása a vágólapra"),
      onPressed: () => Clipboard.setData(ClipboardData(text: desc)),
    ))
    ..add(DialogButton(
      color: Colors.black26.withOpacity(0.1),
      child: Text("Bezárás"),
      onPressed: () => Navigator.of(context).pop(false),
    ));

  Widget content = Container(
    height: MediaQuery.of(context).size.height - 200,
    child: SingleChildScrollView(
      child: Text(
        desc,
        style: TextStyle(fontSize: 10),
      ),
    ),
  );

  return Alert(context: context, title: title, content: content, buttons: buttons, closeFunction: () => "").show();
}

insertSeparators(List<Widget> lst, {double height = 20, double width = 1, Color color = Colors.black26}) {
  if (null != lst && lst.isNotEmpty) {
    List<Widget> _lst = []..addAll(lst);
    lst.clear();
    int i = 0;
    for (Widget w in _lst) {
      lst.add(w);
      i++;
      if (i < _lst.length) {
        lst.add(Container(
          margin: EdgeInsets.symmetric(horizontal: 3),
          height: height,
          width: width,
          color: color,
        ));
      }
    }
  }
}

Text text(String text, {String before, String after, bool addIfnull = false, int maxLines = 2, align = TextAlign.left, Color color, bool bold = false}) {
  String _text = "";
  if (stringNotEmpty(text)) {
    _text = text;
  }
  bool add = stringNotEmpty(text) || addIfnull;
  if (stringNotEmpty(before) && add) {
    _text = "$before$_text";
  }
  if (stringNotEmpty(after) && add) {
    _text = "$text$after";
  }
  return Text(
    _text,
    overflow: TextOverflow.clip,
    softWrap: true,
    maxLines: maxLines,
    textAlign: align,
    style: TextStyle(
      color: color,
      fontWeight: bold ? FontWeight.bold : null,
    ),
  );
}

CheckboxWidget checkBoxWidget(String label, bool value, Function(bool) changedListener) {
  return CheckboxWidget(label, value, changedListener);
}

Widget dividerH({Color color = Colors.black26, double thickness = 1, double height = 10, double margin = 3}) {
  return SizedBox(
    height: 10.0,
    child: new Center(
      child: new Container(
        margin: new EdgeInsetsDirectional.only(start: margin, end: margin),
        height: 1.0,
        color: color,
      ),
    ),
  );
}

Widget buttonGreen(String label, Function onTap) {
  return buttonWithColor(label, onTap, Colors.green.withAlpha(100));
}

Widget buttonWithColor(String label, Function onTap, Color color, {double paddingH = 100, double paddingV = 50}) {
  return InkWell(
    hoverColor: Colors.black12,
    child: Container(color: color, padding: EdgeInsets.symmetric(horizontal: paddingH, vertical: paddingV), child: text(label)),
    onTap: onTap,
  );
}

Widget dividerV({Color color = Colors.black26, double thickness = 1, double height = 10, double margin = 3}) {
  return SizedBox(
    width: 10.0,
    child: new Center(
      child: new Container(
        margin: new EdgeInsetsDirectional.only(top: margin, bottom: margin),
        width: 1.0,
        color: color,
      ),
    ),
  );
}

scrollBarScrollView(List<Widget> child) {
  ScrollController _scrollController = ScrollController();
  if (null == child) {
    child = [];
  }
  if (child.length > 0) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _scrollController.animateTo(1, duration: Duration(milliseconds: 100), curve: Curves.ease);
    });
  }
  return Scrollbar(
      isAlwaysShown: true,
      controller: _scrollController,
      child: ListView(
        controller: _scrollController,
        children: child,
      ));
}
