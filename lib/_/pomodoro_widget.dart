import 'dart:async';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({
    super.key,
  });
  final int defaultTimerSeconds = 1500;
  final int defaultPomodoros = 0;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late int timerSeconds;
  late int pomodoros;
  IconData icon = Icons.play_circle_rounded;
  Timer? timer;

  String format(int seconds) {
    Duration duration = Duration(seconds: seconds);
    String min = duration.inMinutes.toString().padLeft(2, "0");
    String sec = duration.inSeconds.remainder(60).toString().padLeft(2, "0");
    return "$min:$sec";
  }

  void initTimer() {
    setState(() {
      timerSeconds = widget.defaultTimerSeconds;
    });
  }

  void initPomodoro() {
    setState(() {
      pomodoros = widget.defaultPomodoros;
    });
  }

  @override
  void initState() {
    super.initState();
    initTimer();
    initPomodoro();
  }

  void tick(Timer? timer) {
    setState(() {
      timerSeconds == 0
          ? () {
              initTimer();
              pomodoros += 1;
            }()
          : timerSeconds -= 1;
    });
  }

  void onPressedCenterButton() {
    setState(() {
      timer == null
          ? () {
              timer = Timer.periodic(const Duration(seconds: 1), tick);
              icon = Icons.pause_circle_rounded;
            }()
          : () {
              timer!.cancel();
              timer = null;
              icon = Icons.play_circle_rounded;
            }();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      body: Column(
        children: [
          Center(
            child: Text(format(timerSeconds).toString(),
                style: Theme.of(context).textTheme.displayLarge),
          ),
          Expanded(
            child: Center(
              child: IconButton(
                onPressed: onPressedCenterButton,
                icon: Icon(icon),
              ),
            ),
          ),
          Card(
            shape: Theme.of(context).cardTheme.shape,
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        iconSize: Theme.of(context).iconTheme.size! / 2,
                        onPressed: initTimer,
                        icon: Icon(
                          Icons.restart_alt_rounded,
                          color: Theme.of(context).colorScheme.background,
                        ),
                      ),
                      Text(
                        "Pomodoros",
                        style: Theme.of(context).textTheme.displaySmall,
                      ),
                      Text(
                        pomodoros.toString(),
                        style: Theme.of(context).textTheme.displayMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
