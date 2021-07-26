import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/create_scenario.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/scenario_details.dart';
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
    print(_user.isAnonymous);
    firestore.getScenarios(_user.uid).then((value) {
      this.userScenarios = value;
      userScenarios.sort((a, b) => a.difficulty.compareTo(b.difficulty));
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.whiteAppBarBackground,
        title: Text(
          "Scénarios",
          style: TextStyle(color: CustomTheme.black),
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
                  color: CustomTheme.black,
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
                    padding: EdgeInsets.only(left: 12.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(10.0),
                        bottomRight: Radius.circular(10.0),
                      ),
                      color: getScenarioColor(userScenarios[index].difficulty),
                    ),
                    child: Container(
                      decoration: new BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: CustomTheme.white,
                      ),
                      child: ListTile(
                          onTap: () async {
                            Navigator.pushReplacement(
                              context,
                              PageTransition(
                                alignment: Alignment.bottomCenter,
                                curve: Curves.easeInOut,
                                duration: Duration(milliseconds: 300),
                                reverseDuration: Duration(milliseconds: 300),
                                type: PageTransitionType.rightToLeft,
                                child: ScenarioDetails(
                                  scenario: userScenarios[index],
                                ),
                              ),
                            );
                            setState(() {});
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
                  ),
                );
              }),
        ),
      ),
      backgroundColor: CustomTheme.whiteBackground,
    );
  }

  Color getScenarioColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return CustomTheme.paleGreen;
        break;
      case 2:
        return CustomTheme.paleYellow;
        break;
      case 3:
        return CustomTheme.paleRed;
        break;
      default:
        {
          return CustomTheme.white;
        }
    }
  }
}
