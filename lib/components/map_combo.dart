import 'package:flutter/material.dart';

class MapCombo<T> extends StatefulWidget {
  final T Function() value;
  final Function(T) valueChanged;
  final Map<String, T> values;
  final bool Function() validate;
  final String label;
  MapCombo(this.value,this.values, this.valueChanged,{this.validate , this.label});

  @override
  _MapComboState<T> createState() => _MapComboState<T>();
}

class _MapComboState<T> extends State<MapCombo<T>> {
  T get valueInner => widget.value();
  bool get validate {
    if(null != widget.validate){
      return widget.validate();
    }
    return false;
  }
  @override
  Widget build(BuildContext context) {

    return DropdownButtonFormField(
      isExpanded: true,
      items: getItems(),
      value: valueInner,
      onChanged: (value) {
        widget.valueChanged(value);
        setState(() {});
      },

      decoration: InputDecoration(
        labelText: widget.label,
      ),
      validator: (val) => validate ? val == null ? "Nem lehet üres az érték" : null : null,
    );

  }

  List<DropdownMenuItem<T>> getItems() {
    List<DropdownMenuItem<T>> rtn = List.empty(growable: true);
    for (MapEntry<String,T> row in widget.values.entries) {
      rtn.add(DropdownMenuItem<T>(
        child: Text(row.key, overflow: TextOverflow.fade,),
        value: row.value,
      ));
    }
    return rtn;
  }
}
