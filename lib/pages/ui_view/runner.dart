import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Record.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/utils/globals.dart';
import '../../theme.dart';

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
  int startCountdown = 4;
  late List<int> actions;
  bool finished = false;

  @override
  void initState() {
    scenario = widget.scenario;
    actions = scenario.actions;
    super.initState();
    _stopwatch = Stopwatch();
    analytics.logEvent(name: "runScenario");
    _timer = new Timer.periodic(new Duration(milliseconds: 30), (timer) {
      if (!mounted) return;
      setState(() {});
    });
  }

  Future<void> runScenario() async {
    for (var p in pods) {
      p.write(0);
    }
    for (int a in actions) {
      await pods[a - 1].run();
      Future.delayed(const Duration(milliseconds: 100));
    }
    endScenario();
    setState(() {
      _stopwatch!.stop();
    });
  }

  void endScenario() {
    finished = true;
    firestore.createRecord(auth.getCurrentUser()!.uid, scenario,
        Record(DateTime.now(), _stopwatch!.elapsedMilliseconds));
  }

  Future<void> stopScenario() async {
    for (var pod in pods) {
      await pod.write(3);
    }
  }

  void startTimer() {
    startCountdown = 4;
    const oneSec = const Duration(seconds: 1);
    _timer = new Timer.periodic(
      oneSec,
      (Timer timer) {
        if (!mounted) return;
        if (startCountdown == 1) {
          setState(() {
            timer.cancel();
          });
        } else {
          setState(() {
            startCountdown--;
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
      backgroundColor: CustomTheme.greyBackground,
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
                      color: CustomTheme.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Align(
              alignment: FractionalOffset.center,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _stopwatch!.isRunning || finished == true
                      ? Text(
                          finished
                              ? "Scénario terminé\n\nTemps : ${formatTime(_stopwatch!.elapsedMilliseconds)}"
                              : formatTime(_stopwatch!.elapsedMilliseconds),
                          style: TextStyle(
                            fontFamily: 'RobotoBold',
                            fontSize: 35,
                            color: CustomTheme.white,
                          ),
                        )
                      : startCountdown == 4
                          ? GestureDetector(
                              child: Icon(
                                Icons.play_circle_outlined,
                                color: CustomTheme.paleGreen,
                                size: 150,
                              ),
                              onTap: () async {
                                startTimer();
                                await new Future.delayed(
                                    const Duration(seconds: 4));
                                _stopwatch!.start();
                                runScenario();
                              },
                            )
                          : Text(
                              "$startCountdown",
                              style: TextStyle(
                                  fontSize: 60, color: CustomTheme.white),
                            ),
                ],
              ),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 25),
                  child: ElevatedButton(
                    onPressed: () async {
                      stopScenario().then((value) => Navigator.pushReplacement(
                            context,
                            PageTransition(
                                alignment: Alignment.bottomCenter,
                                curve: Curves.easeInOut,
                                duration: Duration(milliseconds: 600),
                                reverseDuration: Duration(milliseconds: 600),
                                type: PageTransitionType.fade,
                                child: HomeScreen(),
                                childCurrent: this.widget),
                          ));
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        "Quitter",
                        style: TextStyle(color: CustomTheme.white),
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: CustomTheme.paleRed,
                      textStyle: TextStyle(
                        fontSize: 50,
                        fontFamily: 'RobotoBold',
                      ),
                      shape: new RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(20.0)),
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    var ms = ((milliseconds % 999) % 100).toString().padLeft(2, '0');

    return "$minutes:$seconds:$ms";
  }

  void finishScenario() {
    firestore.createRecord(auth.getCurrentUser()!.uid, widget.scenario,
        new Record(DateTime.now(), _stopwatch!.elapsedMilliseconds));
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
  }
}
