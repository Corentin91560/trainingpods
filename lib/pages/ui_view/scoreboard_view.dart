import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/widgets/expandable_listview.dart';
import 'package:trainingpods/utils/globals.dart';

import '../../theme.dart';


class ScoreboardView extends StatefulWidget {
  const ScoreboardView({Key? key}) : super(key: key);

  @override
  _ScoreboardViewState createState() => _ScoreboardViewState();
}

class _ScoreboardViewState extends State<ScoreboardView> {
  List<Scenario> userScenarios = [];

  @override
  void initState() {
    firestore.getScenarios(auth.getCurrentUser()!.uid).then((value) {
      for(var s in value) {
        if(s.records.isNotEmpty) {
          this.userScenarios.add(s);
        }
      }
      userScenarios.sort((a, b) => a.name.compareTo(b.name));
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: CustomTheme.whiteBackground,
        appBar: AppBar(
          backgroundColor: CustomTheme.whiteAppBarBackground,
          title: Text(
            "Classement",
            style: TextStyle(color: CustomTheme.black),
          ),
          automaticallyImplyLeading: false,
        ),
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListView.builder(
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.fromLTRB(0,5,0,5),
                  child: new ExpandableListView(
                    scenario: userScenarios[index],
                  ),
                );
              },
              itemCount: userScenarios.length,
            ),
          ),
        ));
  }
}
