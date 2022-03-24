import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  final title;
  final ValueSetter<bool> updateFunction;
  final bool initialValue;

  const CheckboxWidget(
      {Key? key,
      required this.title,
      required this.updateFunction,
      required this.initialValue})
      : super(key: key);

  @override
  State<CheckboxWidget> createState() =>
      _CheckboxWidgetState(this.initialValue);
}

class _CheckboxWidgetState extends State<CheckboxWidget> {
  bool isChecked = false;

  _CheckboxWidgetState(this.isChecked);

  @override
  Widget build(BuildContext context) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.blue;
    }

    return Row(
      children: [
        Text(widget.title),
        Checkbox(
          checkColor: Colors.white,
          fillColor: MaterialStateProperty.resolveWith(getColor),
          value: isChecked,
          onChanged: (bool? value) {
            setState(() {
              isChecked = value!;
            });

            widget.updateFunction(this.isChecked);
          },
        ),
      ],
    );
  }
}
