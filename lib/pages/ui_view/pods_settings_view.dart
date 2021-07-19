import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PodsSettingsView extends StatefulWidget {
  const PodsSettingsView({Key? key}) : super(key: key);

  @override
  _PodsSettingsViewState createState() => _PodsSettingsViewState();
}

class _PodsSettingsViewState extends State<PodsSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Paramètres des TrainingPods",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
      ),
    );
  }
}
