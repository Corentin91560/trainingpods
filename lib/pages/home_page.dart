import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:trainingpods/pages/ui_view/profile_view.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration_view.dart';
import 'package:trainingpods/pages/ui_view/scoreboard_view.dart';
import 'package:trainingpods/pages/ui_view/pods_settings_view.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/tab_icons_data.dart';
import 'package:trainingpods/utils/bottom_bar_view.dart';

class HomeScreen extends StatefulWidget {
  @override
  const HomeScreen({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late User _user;

  List<TabIconData> tabIconsList = TabIconData.tabIconsList;

  Widget tabBody = Container(
    color: CustomTheme.background,
  );

  @override
  void initState() {
    _user = widget._user;
    tabIconsList.forEach((TabIconData tab) {
      tab.isSelected = false;
    });
    tabIconsList[3].isSelected = true;
    tabBody = ProfileView(user: _user);
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
        )
      )
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
              template: TemplateBlueRocket,
            );
            //popup.primaryColor = Colors.lightGreenAccent;
            await popup.recolor(Color(0xFF00FF1E));
            popup.show(
              title: new Text(
                "Scenarios",
                style: TextStyle(fontSize: 35, color: Colors.white, fontFamily: 'RobotoBold'),
              ),
              content: new Scaffold(

              ),
              actions: [
                popup.button(
                  label: 'Play',
                  onPressed: () {
                    //TODO LANCER LE SCENARIO CHOISI
                  },
                ),
              ],
              // bool barrierDismissible = false,
              // Widget close,
            );
          },
          changeIndex: (int index) {
            switch(index) {
              case 0: {
                setState(() {
                  tabBody = ScenariosAdministrationView();
                  this.tabIconsList[0].isSelected = true;
                });
                };
              break;

              case 1: {
                setState(() {
                  tabBody = ScoreboardView();
                  this.tabIconsList[1].isSelected = true;
                });
              }
              break;

              case 2: {
                setState(() {
                  tabBody = PodsSettingsView();
                  this.tabIconsList[2].isSelected = true;
                });
              }
              break;

              case 3: {
                setState(() {
                  tabBody = ProfileView(user: this._user);
                  this.tabIconsList[3].isSelected = true;
                });
              }
              break;
              default: {}
              break;
            }
          },
        ),
      ],
    );
  }
}
