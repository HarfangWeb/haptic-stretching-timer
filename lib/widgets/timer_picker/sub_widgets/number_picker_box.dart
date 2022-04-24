import 'package:flutter/material.dart';
import 'package:stretching_timer/responsive/breakpoints.dart';
import 'package:wheel_chooser/wheel_chooser.dart';

class NumberPickerBox extends StatelessWidget {
  final Function(dynamic) onChangeCallback;
  final int initValue;
  const NumberPickerBox({
    Key? key,
    required this.onChangeCallback,
    required this.initValue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isWatch = MediaQuery.of(context).size.width <= kWatchWidth;
    return SizedBox(
      width: isWatch ? 40 : 60,
      height: isWatch ? 70 : 150,
      child: WheelChooser.integer(
        onValueChanged: onChangeCallback,
        maxValue: 59,
        minValue: 0,
        squeeze: 1,
        initValue: initValue,
        magnification: 1,
        perspective: 0.01,
        itemSize: isWatch ? 24 : 36,
        selectTextStyle: TextStyle(
          fontSize: isWatch ? 12 : 16,
          color: Colors.white70,
        ),
        unSelectTextStyle: TextStyle(
          fontSize: isWatch ? 12 : 16,
        ),
      ),
    );
  }
}
