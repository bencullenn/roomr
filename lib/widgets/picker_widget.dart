import 'package:flutter/material.dart';

// ignore: must_be_immutable
class PickerWidget extends StatefulWidget {
  final List<String> valueList;
  final ValueSetter<String> updateFunction;
  final String title;
  String initialValue;

  PickerWidget(
      {Key? key,
      required this.title,
      required this.valueList,
      required this.updateFunction,
      this.initialValue = ''})
      : super(key: key) {
    if (initialValue == '') {
      initialValue = valueList[0];
    }
  }

  @override
  _PickerWidgetState createState() => _PickerWidgetState(initialValue);
}

class _PickerWidgetState extends State<PickerWidget> {
  String currentValue = '';
  bool initialLoad = true;

  _PickerWidgetState(this.currentValue);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(widget.title),
        DropdownButton<String>(
          value: currentValue,
          elevation: 16,
          style: const TextStyle(color: Colors.blue),
          underline: Container(
            height: 2,
            color: Colors.blueAccent,
          ),
          onChanged: (String? newValue) {
            setState(() {
              currentValue = newValue!;
            });
            widget.updateFunction(currentValue);
          },
          items: widget.valueList.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        )
      ],
    );
  }
}
