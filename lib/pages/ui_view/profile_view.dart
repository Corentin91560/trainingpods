import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingpods/pages/ui_view/sign_in_view.dart';
import 'package:trainingpods/utils/globals.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool imgChanged = false;
  int newPodsCount = -1;

  late File imgFile;
  late User _user;
  late int userPodsCount;

  final FocusNode myFocusNode = FocusNode();
  final nameTFController = TextEditingController();
  final emailTFController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

  Route _routeToSignInScreen() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => SignIn(),
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
    _user = auth.getCurrentUser()!;
    imgFile = new File("");
    nameTFController.text = this._user.displayName!;
    emailTFController.text = this._user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
          backgroundColor: CustomTheme.whiteAppBarBackground,
          title: Text(
            "Profil",
            style: TextStyle(color: CustomTheme.black),
          ),
          automaticallyImplyLeading: false,
        ),
        backgroundColor: CustomTheme.whiteBackground,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: new Container(
            child: new ListView(
              children: <Widget>[
                Column(
                  children: <Widget>[
                    new Container(
                      height: 225.0,
                      color: CustomTheme.whiteBackground,
                      child: new Column(
                        children: <Widget>[
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.only(top: 20.0),
                              child: new Stack(fit: StackFit.loose, children: <
                                  Widget>[
                                new Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    Expanded(
                                      child: ClipRRect(
                                        child: StreamBuilder(
                                          stream:
                                              auth.getInstance().userChanges(),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            if (snapshot.hasData) {
                                              this._user =
                                                  snapshot.data as User;
                                              return imgChanged
                                                  ? Image.file(
                                                      this.imgFile,
                                                      fit: BoxFit.fitHeight,
                                                    )
                                                  : Image.network(
                                                      this._user.photoURL!,
                                                      fit: BoxFit.fitHeight,
                                                    );
                                            } else {
                                              return new Image.asset(
                                                'assets/img/basicUserPicture.jpg',
                                                fit: BoxFit.fitHeight,
                                              );
                                            }
                                          },
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        top: 100.0, right: 120.0),
                                    child: new Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        GestureDetector(
                                          child: new CircleAvatar(
                                            backgroundColor:
                                                CustomTheme.loginGradientStart,
                                            radius: 25.0,
                                            child: new Icon(
                                              Icons.camera_alt,
                                              color: CustomTheme.black,
                                            ),
                                          ),
                                          onTap: () => {
                                            _onImageButtonPressed(
                                              ImageSource.gallery,
                                            )
                                          },
                                        )
                                      ],
                                    )),
                              ]),
                            ),
                          ),
                          Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: new ElevatedButton(
                                child: Text('Se déconnecter'),
                                style: ElevatedButton.styleFrom(
                                    primary: CustomTheme.paleRed,
                                    onPrimary: CustomTheme.black,
                                    shape: new RoundedRectangleBorder(
                                        borderRadius:
                                            new BorderRadius.circular(20.0))),
                                onPressed: () async {
                                  await Authentication.signOut(
                                      context: context);
                                  Navigator.of(context)
                                      .pushReplacement(_routeToSignInScreen());
                                },
                              ))
                        ],
                      ),
                    ),
                    new Container(
                      color: CustomTheme.whiteBackground,
                      child: Padding(
                        padding: EdgeInsets.only(bottom: 25.0),
                        child: new Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Text(
                                      'Informations',
                                      style: TextStyle(
                                          fontSize: 18.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    _status ? _getEditIcon() : new Container()
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Nom',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Flexible(
                                      child: StreamBuilder(
                                          stream:
                                              auth.getInstance().userChanges(),
                                          builder: (context, snapshot) {
                                            if (snapshot.data != null) {
                                              this._user =
                                                  snapshot.data as User;
                                              this.nameTFController.text =
                                                  this._user.displayName ?? "";
                                            }
                                            return new TextField(
                                              controller: nameTFController,
                                              enabled: !_status,
                                              autofocus: !_status,
                                            );
                                          }),
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 25.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    new Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        new Text(
                                          'Nombre de pods',
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ],
                                )),
                            Padding(
                                padding: EdgeInsets.only(
                                    left: 25.0, right: 25.0, top: 2.0),
                                child: new Row(
                                  mainAxisSize: MainAxisSize.max,
                                  children: <Widget>[
                                    Flexible(
                                      child: FutureBuilder<DocumentSnapshot>(
                                          future: firestore
                                              .getCurrentUser(_user.uid),
                                          builder: (context, snapshot) {
                                            if (!snapshot.hasData) {
                                              return Center(
                                                child:
                                                    CircularProgressIndicator(),
                                              );
                                            }
                                            int podsCount = 0;
                                            if (newPodsCount == -1) {
                                              Map<String, dynamic> data =
                                                  snapshot.data!.data()
                                                      as Map<String, dynamic>;
                                              podsCount = data['podsCount'];
                                            } else {
                                              podsCount = newPodsCount;
                                            }
                                            return Column(
                                              children: [
                                                Slider(
                                                  value: podsCount.toDouble(),
                                                  min: 0,
                                                  max: 6,
                                                  divisions: 6,
                                                  label: podsCount
                                                      .round()
                                                      .toString(),
                                                  activeColor: CustomTheme
                                                      .loginGradientStart,
                                                  inactiveColor: CustomTheme
                                                      .greyBackground,
                                                  onChanged: _status
                                                      ? null
                                                      : (double value) {
                                                          setState(() {
                                                            newPodsCount =
                                                                value.toInt();
                                                          });
                                                        },
                                                ),
                                                Text(
                                                  podsCount.toInt().toString(),
                                                  style: TextStyle(
                                                    fontSize: 20,
                                                  ),
                                                ),
                                              ],
                                            );
                                          }),
                                    ),
                                  ],
                                )),
                            !_status ? _getActionButtons() : new Container(),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  void _onImageButtonPressed(ImageSource source,
      {BuildContext? context}) async {
    final pickedFile =
        await _picker.getImage(source: source, imageQuality: 100);
    if (pickedFile != null) {
      try {
        imgFile = File(pickedFile.path);
        await storage.uploadUserProfilePicture(_user.uid, imgFile);
        String imgURL = await storage.getUserProfilePicture(_user.uid);
        await _user.updateProfile(photoURL: imgURL);
        setState(() {
          imgChanged = true;
        });
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  void dispose() {
    myFocusNode.dispose();
    super.dispose();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 25.0, right: 25.0, top: 30.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: Text('Valider'),
                style: ElevatedButton.styleFrom(
                    primary: CustomTheme.loginGradientStart,
                    onPrimary: CustomTheme.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
                onPressed: () async {
                  if (this._user.displayName != nameTFController.text) {
                    await this._user.updateProfile(
                          displayName: this.nameTFController.text,
                        );
                    await this._user.reload();
                  }
                  if (this.newPodsCount != -1) {
                    firestore.updateUser(_user.uid, newPodsCount);
                  }
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                  analytics.setUserProperty("podsCount", newPodsCount);
                },
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new ElevatedButton(
                child: Text('Annuler'),
                style: ElevatedButton.styleFrom(
                    primary: CustomTheme.paleRed,
                    onPrimary: CustomTheme.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
                onPressed: () {
                  setState(() {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return new ElevatedButton(
      child: Text('Modifier'),
      style: ElevatedButton.styleFrom(
          primary: CustomTheme.loginGradientStart,
          onPrimary: CustomTheme.black,
          shape: new RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(20.0))),
      onPressed: () {
        setState(() {
          _status = false;
        });
      },
    );
  }
}
