import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_beautiful_popup/main.dart';
import 'package:trainingpods/pages/login_page.dart';
import 'package:trainingpods/pages/ui_view/profile_view.dart';
import 'package:trainingpods/pages/ui_view/scenarios_administration_view.dart';
import 'package:trainingpods/pages/ui_view/scoreboard_view.dart';
import 'package:trainingpods/pages/ui_view/pods_settings_view.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:trainingpods/utils/tab_icons_data.dart';
import 'package:trainingpods/pages/widgets/bottom_bar_view.dart';

class OldHome extends StatefulWidget {
  const OldHome({Key? key, required User user,required String username})
      : _user = user,
        _username = username,
        super(key: key);

  final User _user;
  final String _username;

  @override
  _OldHomeState createState() => _OldHomeState();
}

class _OldHomeState extends State<OldHome> {
  late User _user;
  late String? _username;
  bool _isSigningOut = false;

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => LoginPage(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(-1.0, 0.0);
        var end = Offset.zero;
        var curve = Curves.ease;

        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  void initState() {
    _user = widget._user;
    _username = widget._username;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CustomTheme.loginGradientStart,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: CustomTheme.loginGradientStart,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            bottom: 20.0,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(),
              _user.photoURL != null
                  ? ClipOval(
                child: Material(
                  color: CustomTheme.loginGradientStart,
                  child: Image.network(
                    _user.photoURL!,
                    fit: BoxFit.fitHeight,
                  ),
                ),
              )
                  : ClipOval(
                child: Material(
                  color: CustomTheme.loginGradientEnd,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: CustomTheme.loginGradientStart,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16.0),
              Text(
                'Hello',
                style: TextStyle(
                  color: CustomTheme.white,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                (_username??_user.displayName)! ,
                style: TextStyle(
                  color: CustomTheme.white,
                  fontSize: 26,
                ),
              ),
              SizedBox(height: 8.0),
              Text(
                '( ${_user.email} )',
                style: TextStyle(
                  color: CustomTheme.white,
                  fontSize: 20,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 24.0),
              Text(
                'You are now signed in using your Google account. To sign out of your account, click the "Sign Out" button below.',
                style: TextStyle(
                    color: CustomTheme.loginGradientStart,
                    fontSize: 14,
                    letterSpacing: 0.2),
              ),
              SizedBox(height: 16.0),
              _isSigningOut
                  ? CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
                  : ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.redAccent,
                  ),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                onPressed: () async {
                  setState(() {
                    _isSigningOut = true;
                  });
                  await Authentication.signOut(context: context);
                  setState(() {
                    _isSigningOut = false;
                  });
                  Navigator.of(context)
                      .pushReplacement(_routeToSignInScreen());
                },
                child: Padding(
                  padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
            //await popup.recolor(Colors.lightGreenAccent);
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
                  }
                ),
                popup.button(
                  label: 'Cancel',
                  onPressed: Navigator.of(context).pop,
                )
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
