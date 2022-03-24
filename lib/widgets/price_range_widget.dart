import 'package:flutter/material.dart';

class PriceRangeWidget extends StatefulWidget {
  final lowerVal;
  final higherVal;
  final ValueSetter<RangeValues> updateFunction;

  const PriceRangeWidget(
      {Key? key,
      required this.lowerVal,
      required this.higherVal,
      required this.updateFunction})
      : super(key: key);

  @override
  State<PriceRangeWidget> createState() => _PriceRangeWidgetState();
}

class _PriceRangeWidgetState extends State<PriceRangeWidget> {
  @override
  Widget build(BuildContext context) {
    RangeValues _currentRangeValues =
        RangeValues(widget.lowerVal, widget.higherVal);
    print('_currentRangeValues:' + _currentRangeValues.toString());
    print('Lower value:' + widget.lowerVal.toString());
    print('Max value:' + widget.higherVal.toString());
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
            children: [
              Text('Price Range: '),
              Text('\$' + _currentRangeValues.start.round().toString()),
              Text(' - '),
              Text('\$' + _currentRangeValues.end.round().toString()),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment:
                CrossAxisAlignment.center //Center Row contents vertically,
            ),
        Row(
            children: [
              Expanded(
                  child: RangeSlider(
                values: _currentRangeValues,
                min: 0,
                max: 3000,
                divisions: 30,
                labels: RangeLabels(
                  '\$' + _currentRangeValues.start.round().toString(),
                  '\$' + _currentRangeValues.end.round().toString(),
                ),
                onChanged: (RangeValues values) {
                  setState(() {
                    _currentRangeValues = values;
                  });

                  widget.updateFunction(_currentRangeValues);
                },
              ))
            ],
            mainAxisAlignment: MainAxisAlignment.center,
            //Center Row contents horizontally,
            crossAxisAlignment: CrossAxisAlignment.center)
      ],
    );
  }
}
