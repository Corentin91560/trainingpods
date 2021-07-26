import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:http/http.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:trainingpods/pages/ui_view/pods_settings/pods_settings_view.dart';
import 'package:trainingpods/pages/ui_view/profile_view.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration/scenarios_administration_view.dart';
import 'package:trainingpods/pages/ui_view/scoreboard_view.dart';
import 'package:trainingpods/pages/ui_view/pods_settings/pods_settings_view.dart';
import 'package:trainingpods/pages/widgets/scenarioPicker.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/globals.dart';
import 'package:trainingpods/utils/tab_icons_data.dart';
import 'package:trainingpods/utils/bottom_bar_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({int? index})
      : _index = index ?? 0,
        super();

  final int _index;

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;
  late List<Scenario> scenarios = [];
  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: CustomTheme.whiteBackground,
  );

  @override
  void initState() {
    _user = auth.getCurrentUser()!;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[widget._index].isSelected = true;
    tabBody = getView();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: CustomTheme.whiteBackground,
      child: Scaffold(
        backgroundColor: CustomTheme.whiteBackground,
        body: Stack(
          children: <Widget>[
            tabBody,
            bottomBar(),
          ],
        ),
      ),
    );
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
            popup.primaryColor = CustomTheme.paleGreen;
            getScenarios().then((value) {
              scenarios.sort((a, b) => a.difficulty.compareTo(b.difficulty));
              popup.show(
                title: new Text(
                  "Scenarios",
                  style: TextStyle(
                      fontSize: 35,
                      color: CustomTheme.white,
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

    List<Scenario> toRemove = [];

    await firestore.getInstance().doc("user/${_user.uid}").get().then((value) {
      Map<String, dynamic> data = value.data()!;
      userPodsCount = data['podsCount'];
    });

    scenarios = await firestore.getScenarios(_user.uid);
    for (var s in scenarios) {
      if (s.podsCount != userPodsCount) {
        toRemove.add(s);
      }
    }
    scenarios.removeWhere((element) => toRemove.contains(element));
  }

  Widget getView() {
    switch (widget._index) {
      case 0:
        return ScenariosAdministrationView();
      case 1:
        return ScoreboardView();
      case 2:
        return PodsSettingsView();
      case 3:
        return ProfileView();
      default:
        return ScenariosAdministrationView();
    }
  }
}
