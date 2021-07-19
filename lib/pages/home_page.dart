import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/ui_view/profile_view.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/scenarios_administration_view.dart';
import 'package:trainingpods/pages/ui_view/scoreboard_view.dart';
import 'package:trainingpods/pages/ui_view/pods_settings_view.dart';
import 'package:trainingpods/pages/widgets/scenarioPicker.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/globals.dart';
import 'package:trainingpods/utils/tab_icons_data.dart';
import 'package:trainingpods/utils/bottom_bar_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  late List<Scenario> scenarios = [];
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: CustomTheme.background,
  );

  @override
  void initState() {
    _user = auth.getCurrentUser()!;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[0].isSelected = true;
    tabBody = ScenariosAdministrationView();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: CustomTheme.background,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            body: Stack(
              children: <Widget>[
                tabBody,
                bottomBar(),
              ],
            )));
  }

  Widget bottomBar() {
    return Column(
      children: <Widget>[
        const Expanded(
          child: SizedBox(),
        ),
        BottomBarView(
          tabIconsList: tabIconsList,
          runClick: () async {
            final popup = BeautifulPopup(
              context: context,
              template: TemplateGreenRocket,
            );
            //popup.primaryColor = Colors.lightGreenAccent;
            //await popup.recolor(Color(0xFF00FF1E));
            getScenarios().then((value) {
              scenarios.sort((a, b) => a.difficulty.compareTo(b.difficulty));
              popup.show(
                title: new Text(
                  "Scenarios",
                  style: TextStyle(
                      fontSize: 35,
                      color: Colors.white,
                      fontFamily: 'RobotoBold'),
                ),
                content: scenarioPicker(scenarioList: scenarios),
                // bool barrierDismissible = false,
                // Widget close,
              );
            });
          },
          changeIndex: (int index) {
            switch (index) {
              case 0:
                {
                  setState(() {
                    tabBody = ScenariosAdministrationView();
                    this.tabIconsList[0].isSelected = true;
                  });
                }
                ;
                break;

              case 1:
                {
                  setState(() {
                    tabBody = ScoreboardView();
                    this.tabIconsList[1].isSelected = true;
                  });
                }
                break;

              case 2:
                {
                  setState(() {
                    tabBody = PodsSettingsView();
                    this.tabIconsList[2].isSelected = true;
                  });
                }
                break;

              case 3:
                {
                  setState(() {
                    tabBody = ProfileView();
                    this.tabIconsList[3].isSelected = true;
                  });
                }
                break;
              default:
                {}
                break;
            }
          },
        ),
      ],
    );
  }

  Future<void> getScenarios() async {
    var userPodsCount = -1;
    scenarios.clear();

    await firestore.getInstance().doc("user/${_user.uid}").get().then((value) {
      Map<String, dynamic> data = value.data()!;
      userPodsCount = data['podsCount'];
    });

    await FirebaseFirestore.instance
        .collection('user/${_user.uid}/scenarios')
        .get()
        .then((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          if (doc.data()['podsCount'] == userPodsCount) {
            List<int> actions = List.from(doc.data()['actions']);
            this.scenarios.add(new Scenario(
                doc.data()['name'],
                doc.data()['difficulty'],
                DateTime.parse(doc.data()['creationDate'].toDate().toString()),
                doc.data()['played'],
                actions,
                doc.data()['bestTime'],
                doc.data()['podscount']));
          }
        }
      }
    });
  }
}
