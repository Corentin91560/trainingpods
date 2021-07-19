import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/create_scenario.dart';
import 'package:trainingpods/theme.dart';
import 'package:intl/intl.dart';
import 'package:trainingpods/utils/globals.dart';

class ScenariosAdministrationView extends StatefulWidget {
  @override
  _ScenariosAdministrationViewState createState() =>
      _ScenariosAdministrationViewState();
}

class _ScenariosAdministrationViewState
    extends State<ScenariosAdministrationView> {
  late List<Scenario> userScenarios = [];
  late User _user;

  @override
  void initState() {
    _user = auth.getCurrentUser()!;
    getScenarios().then((value) {
      userScenarios.sort((a, b) => a.difficulty.compareTo(b.difficulty));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white70,
        title: Text(
          "Scénarios",
          style: TextStyle(color: Colors.black),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                    context,
                    PageTransition(
                        alignment: Alignment.bottomCenter,
                        curve: Curves.easeInOut,
                        duration: Duration(milliseconds: 300),
                        reverseDuration: Duration(milliseconds: 300),
                        type: PageTransitionType.rightToLeft,
                        child: CreateScenario(),
                        childCurrent: context.widget),
                  );
                },
                child: Icon(
                  Icons.add,
                  size: 26.0,
                  color: Colors.black,
                ),
              )),
        ],
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: ListView.builder(
              itemCount: userScenarios.length,
              itemBuilder: (context, index) {
                return Card(
                  child: Container(
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        border: Border(
                            left: BorderSide(
                          color:
                              getScenarioColor(userScenarios[index].difficulty),
                          width: 5,
                        ))),
                    child: ListTile(
                        onTap: () {
                          setState(() {
                            print("Scénario $index clicked");
                          });
                        },
                        title: Text(userScenarios[index].name),
                        subtitle: Row(
                          children: [
                            Text(
                                "Crée le : ${DateFormat('dd/MM/yyyy').format(userScenarios[index].creationDate)}"),
                            Spacer(),
                            Text("Joué ${userScenarios[index].played} fois"),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios_rounded)),
                  ),
                );
              }),
        ),
      ),
      backgroundColor: Colors.white24,
    );
  }

  Color getScenarioColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return CustomTheme.TrainingPodsGreen;
        break;
      case 2:
        return Colors.yellowAccent;
        break;
      case 3:
        return Colors.redAccent;
        break;
      default:
        {
          return Colors.white;
        }
    }
  }

  Future<void> getScenarios() async {
    await FirebaseFirestore.instance
        .collection('user/${_user.uid}/scenarios')
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          List<int> actions = List.from(doc.data()['actions']);
          this.userScenarios.add(new Scenario(
              doc.data()['name'],
              doc.data()['difficulty'],
              DateTime.parse(doc.data()['creationDate'].toDate().toString()),
              doc.data()['played'],
              actions,
              doc.data()['bestTime'],
              doc.data()['podsCount']));
        }
      }
    });
  }
}
