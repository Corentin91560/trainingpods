import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/ui_view/runner.dart';
import '../../theme.dart';

class scenarioPicker extends StatefulWidget {
  const scenarioPicker({Key? key, required List<Scenario> scenarioList})
      : scenarios = scenarioList,
        super(key: key);

  final List<Scenario> scenarios;

  @override
  _scenarioPickerState createState() => _scenarioPickerState();
}

class _scenarioPickerState extends State<scenarioPicker> {
  late List<Scenario> scenarios;

  @override
  void initState() {
    this.scenarios = widget.scenarios;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white24,
      child: MediaQuery.removePadding(
        removeTop: true,
        context: context,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: scenarios.isEmpty
              ? Center(
                  child: Text("Aucun scénario avec votre nombre de pods"),
                )
              : GridView.builder(
                  itemCount: scenarios.length,
                  shrinkWrap: true,
                  physics: const ClampingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                  ),
                  itemBuilder: (context, index) {
                    return Card(
                      child: GestureDetector(
                        child: GridTile(
                          child: Center(
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.fromLTRB(5, 2, 5, 0),
                                  child: Column(
                                    children: [
                                      Text(
                                        scenarios[index].name,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 10,
                                          fontFamily: 'RobotoBold',
                                        ),
                                      ),
                                      Padding(
                                        padding: EdgeInsets.fromLTRB(
                                            0,
                                            MediaQuery.of(context).size.width /
                                                50,
                                            0,
                                            MediaQuery.of(context).size.width /
                                                50),
                                        child: Text(
                                          "Joué ${scenarios[index].played} fois ",
                                          style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontFamily: 'Roboto',
                                          ),
                                        ),
                                      ),
                                      Center(
                                        child: Icon(
                                          Icons.play_circle_outlined,
                                          color: CustomTheme.white,
                                          size: 20,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
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
                                child: Runner(
                                  pScenario: scenarios[index],
                                ),
                                childCurrent: context.widget),
                          );
                        },
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: getScenarioColor(scenarios[index].difficulty),
                    );
                  }),
        ),
      ),
    );
  }

  Color getScenarioColor(int difficulty) {
    switch (difficulty) {
      case 1:
        return Color(0xFF9CCE96);
        break;
      case 2:
        return Color(0xFFE4EB88);
        break;
      case 3:
        return Color(0xFFCE9697);
        break;
      default:
        {
          return Colors.white;
        }
    }
  }
}
