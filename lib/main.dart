import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stretching_timer/responsive/breakpoints.dart';
import 'package:stretching_timer/widgets/countdown.dart';
import 'package:stretching_timer/widgets/timer_picker/timer_picker.dart';
import 'package:vibration/vibration.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Stretching Timer',
      theme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      home: const SafeArea(
        child: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  Duration _timerDuration = const Duration(seconds: 60);
  bool _isTimerRunning = false;
  bool _isTimerPaused = false;
  int _secondsCounter = 60;
  late Timer _timer;
  late AnimationController _circularProgressController;
  late double progress;

  @override
  void initState() {
    super.initState();
    _circularProgressController =
        AnimationController(vsync: this, duration: _timerDuration);
    _circularProgressController.addListener(() {
      if (_circularProgressController.isAnimating) {
        setState(() {
          progress = _circularProgressController.value;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _circularProgressController;
  }

  void setTimerDuration(Duration duration) {
    setState(() {
      _timerDuration = duration;
      _circularProgressController.duration = duration;
    });
  }

  void startTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      _secondsCounter = _timerDuration.inSeconds;
      _circularProgressController.reverse(from: 1);

      _timer = Timer.periodic(const Duration(seconds: 1), ((timer) {
        setState(() {
          if (_isTimerPaused == false) {
            _secondsCounter--;
          }

          if (_secondsCounter == 0) {
            //haptic feedback
            //HapticFeedback.vibrate();
            Vibration.vibrate(duration: 500, intensities: [200]);

            _secondsCounter = _timerDuration.inSeconds;
            _circularProgressController.reverse(from: 1);
          }
        });
      }));
    });
  }

  void stopTimer() {
    setState(() {
      _isTimerRunning = !_isTimerRunning;
      _isTimerPaused = false;
      _timer.cancel();
      _circularProgressController.stop();
    });
  }

  void pauseTimer() {
    setState(() {
      if (_isTimerPaused == false) {
        _circularProgressController.stop();
      } else {
        _circularProgressController.reverse(
            from: _circularProgressController.value);
        //restart timer,
      }

      _isTimerPaused = !_isTimerPaused;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    bool smallDevice = width <= kWatchWidth;
    return Scaffold(
      appBar: smallDevice
          ? null
          : AppBar(
              title: const Center(
                  child: Text(
                'Stretching Timer',
              )),
            ),
      body: Center(
        child: Column(
          mainAxisAlignment: smallDevice
              ? MainAxisAlignment.start
              : MainAxisAlignment.spaceAround,
          children: [
            SizedBox(
              width: smallDevice ? 130 : 250,
              height: smallDevice ? 130 : 250,
              child: Padding(
                padding: const EdgeInsets.only(top: 6),
                child: CircleAvatar(
                  backgroundColor: Colors.white10,
                  child: _isTimerRunning
                      ? Stack(
                          fit: StackFit.expand,
                          children: [
                            CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 8,
                            ),
                            Countdown(
                              seconds: _secondsCounter,
                            ),
                          ],
                        )
                      : TimerPicker(
                          onTimerDurationChanged: setTimerDuration,
                          initialDuration: _timerDuration,
                        ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: smallDevice
                  ? MainAxisAlignment.spaceBetween
                  : MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: _isTimerRunning ? stopTimer : startTimer,
                  iconSize: smallDevice ? 40 : 100,
                  icon: _isTimerRunning
                      ? const Icon(
                          Icons.stop_circle_outlined,
                          color: Colors.red,
                        )
                      : const Icon(
                          Icons.not_started_outlined,
                          color: Colors.green,
                        ),
                ),
                IconButton(
                  onPressed: _isTimerRunning ? pauseTimer : null,
                  iconSize: smallDevice ? 40 : 100,
                  icon: _isTimerPaused
                      ? const Icon(
                          Icons.play_circle_outline,
                          color: Colors.green,
                        )
                      : const Icon(
                          Icons.pause_circle_outlined,
                        ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
