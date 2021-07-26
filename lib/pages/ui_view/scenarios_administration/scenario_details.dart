import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/utils/globals.dart';

import '../../../theme.dart';
import '../../home_page.dart';
import 'create_scenarios_actions.dart';

class ScenarioDetails extends StatefulWidget {
  const ScenarioDetails({Key? key, required Scenario scenario})
      : this.scenario = scenario,
        super(key: key);

  final Scenario scenario;

  @override
  _ScenarioDetailsState createState() => _ScenarioDetailsState();
}

class _ScenarioDetailsState extends State<ScenarioDetails> {
  late Scenario _scenario;
  String difficultyValue = "";
  int podsCountValue = 0;
  List<int> actionsList = [];
  final nameController = TextEditingController();
  bool errorVisibility = false;
  String errorText = "";
  List<int> newActionsList = [];

  @override
  void initState() {
    this._scenario = widget.scenario;
    this.difficultyValue = getDifficultyString();
    this.nameController.text = _scenario.name;
    this.podsCountValue = _scenario.podsCount;
    this.actionsList = _scenario.actions;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.whiteAppBarBackground,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: CustomTheme.black),
          onPressed: () =>
              Navigator.pushReplacement(
                context,
                PageTransition(
                  alignment: Alignment.bottomCenter,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.leftToRight,
                  child: HomeScreen(),
                ),
              ),
        ),
        title: Text(
          _scenario.name,
          style: TextStyle(color: CustomTheme.black),
        ),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Center(
                        child: Text(
                          'Suppresion de \"${_scenario.name}\"',
                          textAlign: TextAlign.center,
                        ),
                      ),
                      content: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Container(
                            child: Text(
                              "Confirmez vous la suppression du scénario \"${_scenario
                                  .name}\" ? ",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontFamily: 'Roboto',
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                TextButton(
                                  child: Text(
                                    'Supprimer',
                                    style: TextStyle(color: CustomTheme.red),
                                  ),
                                  onPressed: () {
                                    firestore
                                        .deleteScenario(_scenario,
                                        auth.getCurrentUser()!.uid)
                                        .then(
                                          (value) {
                                        Navigator.pushReplacement(
                                          context,
                                          PageTransition(
                                            alignment: Alignment.bottomCenter,
                                            curve: Curves.easeInOut,
                                            duration:
                                            Duration(milliseconds: 300),
                                            reverseDuration:
                                            Duration(milliseconds: 300),
                                            type: PageTransitionType.fade,
                                            child: HomeScreen(),
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                                TextButton(
                                  child: Text('Annuler'),
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ],
                            ),
                          )
                        ],
                      ),
                    );
                  },
                );
              },
              child: Icon(
                Icons.delete_outlined,
                size: 26.0,
                color: CustomTheme.red,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: CustomTheme.whiteBackground,
      body: Padding(
        padding: const EdgeInsets.all(50),
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
              padding: const EdgeInsets.only(top: 15),
              child: TextField(
                onChanged: (text) {
                  if (text != "") {
                    setState(
                          () {
                        errorVisibility = false;
                      },
                    );
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
                  fillColor: CustomTheme.whiteAppBarBackground,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75),
              child: Text(
                "Difficulté :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoBold',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10),
              child: CupertinoSegmentedControl(
                borderColor: CustomTheme.whiteBackground,
                pressedColor: CustomTheme.whiteBackground,
                unselectedColor: CustomTheme.whiteBackground,
                children: {
                  'Facile': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Facile'
                          ? CustomTheme.paleGreen
                          : CustomTheme.whiteBackground,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Facile',
                      style: TextStyle(color: CustomTheme.black, fontSize: 15),
                    ),
                  ),
                  'Moyen': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Moyen'
                          ? CustomTheme.paleYellow
                          : CustomTheme.whiteBackground,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Moyen',
                      style: TextStyle(color: CustomTheme.black, fontSize: 15),
                    ),
                  ),
                  'Difficile': Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      color: difficultyValue == 'Difficile'
                          ? CustomTheme.paleRed
                          : CustomTheme.whiteBackground,
                    ),
                    padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                    child: Text(
                      'Difficile',
                      style: TextStyle(color: CustomTheme.black, fontSize: 15),
                    ),
                  ),
                },
                onValueChanged: (value) {
                  setState(
                        () {
                      difficultyValue = value.toString();
                    },
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 75),
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
              label: podsCountValue.toString(),
              activeColor: getColor(),
              onChanged: (double value) {
                setState(
                      () {
                    errorVisibility = false;
                    podsCountValue = value.toInt();
                  },
                );
              },
            ),
            Text(
              podsCountValue.toInt().toString(),
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "Actions :",
                style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'RobotoBold',
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15),
              child: actionsList.isEmpty
                  ? ElevatedButton(
                onPressed: () async {
                  if (!errorHandler()) {
                    this.errorVisibility = false;
                    await navigateAndGetActions(context);
                  }
                  setState(() {});
                },
                child: Text(
                  "Configurer scénario",
                  style: TextStyle(color: CustomTheme.black),
                ),
                style: ElevatedButton.styleFrom(
                  primary: getColor(),
                  padding:
                  EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                  textStyle: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    onPressed: () async {
                      if (!errorHandler()) {
                        this.errorVisibility = false;
                        await navigateAndGetActions(context);
                      }
                      setState(() {});
                    },
                    child: Text(
                      "Changer",
                      style: TextStyle(color: CustomTheme.black),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: getColor(),
                      textStyle: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.normal,
                      ),
                    ),
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
                    color: CustomTheme.red,
                    fontFamily: 'RobotoBold',
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: CustomTheme.paleGreen,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.done_outlined,
                    color: CustomTheme.black,
                    size: 50,
                  ),
                  onPressed: () {
                    if (actionsList.isEmpty) {
                      this.errorText = "Veuillez configurer le scénario !";
                      setState(() {
                        this.errorVisibility = true;
                      });
                    } else {
                      firestore.updateScenario(
                          Scenario(
                              nameController.text,
                              getDifficultyNumber(),
                              _scenario.creationDate,
                              _scenario.played,
                              actionsList,
                              _scenario.bestTime,
                              podsCountValue,
                              _scenario.records,
                              pId: _scenario.id),
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
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> navigateAndGetActions(BuildContext context) async {
    final List<int> result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              ActionsChooser(
                podsCount: podsCountValue,
                actions: actionsList,
              )),
    );
    if (result.isEmpty) {
      newActionsList = [];
    } else {
      newActionsList = result;
    }
    setState(() {});
  }

  Color getColor() {
    switch (difficultyValue) {
      case 'Facile':
        return CustomTheme.paleGreen;
      case 'Moyen':
        return CustomTheme.paleYellow;
      case 'Difficile':
        return CustomTheme.paleRed;
      default:
        {
          return CustomTheme.black;
        }
    }
  }

  String actionsStringBuilder() {
    String actions = "";

    if (newActionsList.isEmpty) {
      for (var a in actionsList) {
        actions += "$a -> ";
      }
    } else {
      for (var a in newActionsList) {
        actions += "$a -> ";
      }
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

  String getDifficultyString() {
    switch (_scenario.difficulty) {
      case 1:
        return 'Facile';
      case 2:
        return 'Moyen';
      case 3:
        return 'Difficile';
      default:
        {
          return "";
        }
    }
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
