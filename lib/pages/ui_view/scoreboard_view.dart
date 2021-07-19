import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ScoreboardView extends StatefulWidget {
  const ScoreboardView({Key? key}) : super(key: key);

  @override
  _ScoreboardViewState createState() => _ScoreboardViewState();
}

class _ScoreboardViewState extends State<ScoreboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Classement",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
