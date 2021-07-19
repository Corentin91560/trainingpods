import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/utils/globals.dart';

class Runner extends StatefulWidget {
  const Runner({Key? key, required Scenario pScenario})
      : scenario = pScenario,
        super(key: key);

  final Scenario scenario;

  @override
  _RunnerState createState() => _RunnerState();
}

class _RunnerState extends State<Runner> {
  Stopwatch? _stopwatch;
  Timer? _timer;
  late Scenario scenario;
  int _start = 3;

  @override
  void initState() {
    scenario = widget.scenario;
    super.initState();
    _stopwatch = Stopwatch();
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {});
    });
  }

  void handleStartStop() async {
    if (_stopwatch!.isRunning) {
      _stopwatch!.stop();
      //TODO STOP SCENARIO
    } else {
      startTimer();
      await new Future.delayed(const Duration(seconds: 3));
      _stopwatch!.start();
      //TODO START SCENARIO
    }
    if (!mounted) return;
    setState(() {}); // re-render the page
  }

  void startTimer() {

    _start = 3;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) return;
        if (_start == 0) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    _timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white10,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            Align(
              alignment: FractionalOffset.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  scenario.name,
                  style: TextStyle(
                      fontSize: 48.0,
                      fontFamily: 'RobotoBold',
                      color: Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    child: Icon(
                      _stopwatch!.isRunning
                          ? Icons.pause_circle_outlined
                          : Icons.play_circle_outlined,
                      color:
                          _stopwatch!.isRunning ? Colors.yellow : Colors.green,
                      size: 150,
                    ),
                    onTap: handleStartStop,
                  ),
                  _start == 0
                      ? Text(
                          formatTime(_stopwatch!.elapsedMilliseconds),
                          style: TextStyle(fontSize: 48.0, color: Colors.white),
                        )
                      : Text(
                          "$_start",
                          style: TextStyle(fontSize: 60, color: Colors.white),
                        )
                ],
              ),
            ),
            Align(
              alignment: FractionalOffset.bottomCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  _stopwatch!.isRunning
                      ? Spacer()
                      : GestureDetector(
                          child: Icon(
                            Icons.stop_circle_outlined,
                            color: Colors.red,
                            size: 150,
                          ),
                          onTap: () {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 600),
                                  reverseDuration: Duration(milliseconds: 600),
                                  type: PageTransitionType.fade,
                                  child: HomeScreen(),
                                  childCurrent: this.widget),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

String formatTime(int milliseconds) {
  var secs = milliseconds ~/ 1000;
  var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
  var seconds = (secs % 60).toString().padLeft(2, '0');
  var ms = ((milliseconds % 999) % 100).toString().padLeft(2, '0');

  return "$minutes:$seconds:$ms";
}
