import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/create_scenarios_actions.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/scenarios_administration_view.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/utils/globals.dart';

class CreateScenario extends StatefulWidget {
  const CreateScenario({Key? key}) : super(key: key);

  @override
  _CreateScenarioState createState() => _CreateScenarioState();
}

class _CreateScenarioState extends State<CreateScenario> {
  String difficultyValue = "Facile";
  int podsCountValue = 0;
  List<int> actionsList = [];
  final nameController = TextEditingController();
  bool errorVisibility = false;
  String errorText = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white70,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pushReplacement(
            context,
            PageTransition(
                alignment: Alignment.bottomCenter,
                curve: Curves.easeInOut,
                duration: Duration(milliseconds: 300),
                reverseDuration: Duration(milliseconds: 300),
                type: PageTransitionType.leftToRight,
                child: HomeScreen(),
                childCurrent: context.widget),
          ),
        ),
        title: Text(
          "Nouveau Scénario",
          style: TextStyle(color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(50, 50, 50, 50),
        child: Column(
          children: [
            Text(
              "Nom du scénario :",
              style: TextStyle(
                fontSize: 18,
                fontFamily: 'RobotoBold',
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: TextField(
                onChanged: (text) {
                  if (text != "") {
                    setState(() {
                      errorVisibility = false;
                    });
                  }
                },
                controller: nameController,
                textAlign: TextAlign.center,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  hintText: 'Nom',
                  hintStyle: TextStyle(fontSize: 16),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(50),
                    borderSide: BorderSide(
                      width: 0,
                      style: BorderStyle.none,
                    ),
                  ),
                  filled: true,
                  contentPadding: EdgeInsets.all(16),
                  fillColor: Colors.grey[200],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
              child: Text(
                "Difficulté :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoBold',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
              child: CupertinoSegmentedControl(
                borderColor: Colors.white,
                pressedColor: Colors.white,
                children: {
                  'Facile': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Facile'
                          ? Colors.greenAccent[100]
                          : Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Facile',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  'Moyen': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Moyen'
                          ? Colors.yellow[100]
                          : Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Moyen',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                  'Difficile': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Difficile'
                          ? Colors.redAccent[100]
                          : Colors.white,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Difficile',
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  setState(() {
                    difficultyValue = value.toString();
                  });
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
              child: Text(
                "Nombre de pods :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoBold',
                ),
              ),
            ),
            Slider(
              value: podsCountValue.toDouble(),
              min: 0,
              max: 6,
              divisions: 6,
              label: podsCountValue.round().toString(),
              activeColor: getColor(),
              onChanged: (double value) {
                setState(() {
                  errorVisibility = false;
                  podsCountValue = value.toInt();
                });
              },
            ),
            Text(
              podsCountValue.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 75, 0, 0),
              child: Text(
                "Actions :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoBold',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 15, 0, 0),
              child: actionsList.isEmpty
                  ? ElevatedButton(
                      onPressed: () async {
                        if (!errorHandler()) {
                          await navigateAndGetActions(context);
                        }
                        setState(() {});
                      },
                      child: Text(
                        "Configurer scénario",
                        style: TextStyle(color: Colors.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          primary: getColor(),
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    )
                  : Column(
                      children: [
                        Text(
                          actionsStringBuilder(),
                          style: TextStyle(fontSize: 14, fontFamily: 'Roboto'),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              navigateAndGetActions(context);
                            });
                          },
                          child: Text(
                            "Changer",
                            style: TextStyle(color: Colors.black),
                          ),
                          style: ElevatedButton.styleFrom(
                              primary: getColor(),
                              textStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.normal,
                              )),
                        )
                      ],
                    ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Visibility(
                visible: errorVisibility,
                child: Text(
                  errorText,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.red,
                    fontFamily: 'RobotoBold',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 30, 0, 0),
              child: ElevatedButton(
                onPressed: () async {
                  if (actionsList.isEmpty) {
                    this.errorText = "Veuillez configurer le scénario !";
                    setState(() {
                      this.errorVisibility = true;
                    });
                  } else {
                    await firestore.createScenario(
                        Scenario(
                            nameController.text,
                            getDifficultyNumber(),
                            DateTime.now(),
                            0,
                            actionsList,
                            0.0,
                            podsCountValue),
                        auth.getCurrentUser()!.uid);
                    Navigator.pushReplacement(
                      context,
                      PageTransition(
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          type: PageTransitionType.fade,
                          child: HomeScreen(),
                          childCurrent: context.widget),
                    );
                  }
                },
                child: Text(
                  "Valider",
                  style: TextStyle(color: Colors.black),
                ),
                style: ElevatedButton.styleFrom(
                    shape: new RoundedRectangleBorder(
                      borderRadius: new BorderRadius.circular(30.0),
                    ),
                    primary: Colors.green,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    )),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> navigateAndGetActions(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => ActionsChooser(podsCount: podsCountValue)),
    );
    if (result[0] != -1) {
      actionsList = result as List<int>;
    }
  }

  Color getColor() {
    switch (difficultyValue) {
      case 'Facile':
        return Colors.greenAccent[100]!;
      case 'Moyen':
        return Colors.yellow[100]!;
      case 'Difficile':
        return Colors.redAccent[100]!;
      default:
        {
          return Colors.black;
        }
    }
  }

  String actionsStringBuilder() {
    String actions = "";
    for (var a in actionsList) {
      actions += "$a -> ";
    }

    actions = actions.substring(0, actions.length - 4);
    return actions;
  }

  bool errorHandler() {
    if (podsCountValue == 0) {
      this.errorText = "Veuillez choisir un nombre de pods !";
      this.errorVisibility = true;
      return true;
    }
    if (nameController.text == "") {
      this.errorText = "Veuillez choisir un nom !";
      this.errorVisibility = true;
      return true;
    }
    return false;
  }

  int getDifficultyNumber() {
    switch (difficultyValue) {
      case 'Facile':
        return 1;
      case 'Moyen':
        return 2;
      case 'Difficile':
        return 3;
      default:
        {
          return 0;
        }
    }
  }
}
