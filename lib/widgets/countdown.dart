import 'package:flutter/material.dart';

//This widget returns a

class Countdown extends StatelessWidget {
  const Countdown({
    Key? key,
    required this.seconds,
  }) : super(key: key);
  final int seconds;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool smallDevice = width <= 380;

    String countdown = '';
    if (seconds >= 600) {
      countdown += '${seconds ~/ 60}:';
    } else if (seconds >= 60) {
      countdown += '0${seconds ~/ 60}:';
    } else {
      countdown += '00:';
    }
    if (seconds % 60 >= 10) {
      countdown += '${seconds % 60}';
    } else {
      countdown += '0${seconds % 60}';
    }
    return Center(
      child: Text(
        countdown,
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: smallDevice ? 30 : 58,
            color: Colors.white),
      ),
    );
  }
}
