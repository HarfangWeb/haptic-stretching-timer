import 'package:flutter/material.dart';
import 'package:stretching_timer/widgets/timer_picker/sub_widgets/number_picker_box.dart';

class TimerPicker extends StatefulWidget {
  final Function(Duration) onTimerDurationChanged;
  final Duration initialDuration;

  const TimerPicker(
      {Key? key,
      required this.onTimerDurationChanged,
      required this.initialDuration})
      : super(key: key);

  @override
  State<TimerPicker> createState() => _TimerPickerState();
}

class _TimerPickerState extends State<TimerPicker> {
  int minutes = 1;
  int seconds = 0;
  Duration duration = const Duration(seconds: 60);

  @override
  void initState() {
    super.initState();
    duration = widget.initialDuration;
    minutes = widget.initialDuration.inMinutes;
    seconds = widget.initialDuration.inSeconds % 60;
  }

  dynamic secondsUpdater(dynamic value) {
    seconds = value;
    durationUpdater();
  }

  dynamic minutesUpdater(dynamic value) {
    minutes = value;
    durationUpdater();
  }

  void durationUpdater() {
    duration = Duration(minutes: minutes, seconds: seconds);
    widget.onTimerDurationChanged(duration);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        NumberPickerBox(
          initValue: minutes,
          onChangeCallback: minutesUpdater,
        ),
        const Text(' : '),
        NumberPickerBox(
          initValue: seconds,
          onChangeCallback: secondsUpdater,
        ),
      ],
    );
  }
}
