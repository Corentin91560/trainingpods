import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:trainingpods/pages/login_page.dart';
import 'package:image_picker/image_picker.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({Key? key, required User user})
      : _user = user,
        super(key: key);
  final User _user;

  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<ProfileView>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  bool _isSigningOut = false;
  bool imgChanged = false;

  late File imgFile;
  late User _user;

  final FocusNode myFocusNode = FocusNode();
  final nameTFController = TextEditingController();
  final emailTFController = TextEditingController();
  final ImagePicker _picker = ImagePicker();

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
    imgFile = new File("");
    nameTFController.text = this._user.displayName!;
    emailTFController.text = this._user.email!;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        body: GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: new Container(
        color: Colors.white,
        child: new ListView(
          children: <Widget>[
            Column(
              children: <Widget>[
                new Container(
                  height: 225.0,
                  color: Colors.white,
                  child: new Column(
                    children: <Widget>[
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 20.0),
                          child:
                              new Stack(fit: StackFit.loose, children: <Widget>[
                            new Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Expanded(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(50),
                                    child: StreamBuilder(
                                      stream:
                                          FirebaseAuth.instance.userChanges(),
                                      builder: (context, snapshot) {
                                        if (snapshot.hasData) {
                                          this._user = snapshot.data as User;
                                          return imgChanged
                                              ? Image.file(
                                                  this.imgFile,
                                                  width: 140,
                                                  height: 140,
                                                  fit: BoxFit.fitHeight,
                                                )
                                              : Image.network(
                                                  this._user.photoURL!,
                                                  width: 140,
                                                  height: 140,
                                                  fit: BoxFit.fitHeight,
                                                );
                                        } else {
                                          return new Image.asset(
                                            'assets/img/basicUserPicture.jpg',
                                            width: 140,
                                            height: 140,
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
                                padding:
                                    EdgeInsets.only(top: 90.0, right: 100.0),
                                child: new Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    GestureDetector(
                                      child: new CircleAvatar(
                                        backgroundColor:
                                            CustomTheme.loginGradientStart,
                                        radius: 25.0,
                                        child: new Icon(
                                          Icons.camera_alt,
                                          color: Colors.black,
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
                                primary: CustomTheme.TrainingPodsRed,
                                onPrimary: Colors.black,
                                shape: new RoundedRectangleBorder(
                                    borderRadius:
                                        new BorderRadius.circular(20.0))),
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
                          ))
                    ],
                  ),
                ),
                new Container(
                  color: Color(0xffFFFFFF),
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  mainAxisAlignment: MainAxisAlignment.start,
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
                                          FirebaseAuth.instance.userChanges(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          this._user = snapshot.data as User;
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
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    new Text(
                                      'Adresse email',
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
                                          FirebaseAuth.instance.userChanges(),
                                      builder: (context, snapshot) {
                                        if (snapshot.data != null) {
                                          this._user = snapshot.data as User;
                                          this.emailTFController.text =
                                              this._user.email ?? "";
                                        }
                                        return new TextField(
                                          controller: emailTFController,
                                          enabled: !_status,
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
        setState(() async {
          imgChanged = true;
          imgFile = File(pickedFile.path);
          await FirebaseStorage.instance
              .ref('/profilePictures/${_user.uid}.jpeg')
              .putFile(imgFile);
          String imgURL = await FirebaseStorage.instance
              .ref('profilePictures/${_user.uid}.jpeg')
              .getDownloadURL();
          await _user.updateProfile(photoURL: imgURL);
        });
      } on FirebaseException catch (e) {
        if (e.code == 'permission-denied') {
          print('User does not have permission to upload to this reference.');
        } else {
          print('No image selected');
        }
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
                    primary: CustomTheme.TrainingPodsGreen,
                    onPrimary: Colors.black,
                    shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0))),
                onPressed: () async {
                  setState(() async {
                    _status = true;
                    FocusScope.of(context).requestFocus(new FocusNode());
                    if ((this._user.displayName != nameTFController.text) ||
                        (this._user.email != emailTFController.text)) {
                      if (this._user.displayName != nameTFController.text) {
                        await this._user.updateProfile(
                              displayName: this.nameTFController.text,
                            );
                        await this._user.reload();
                      }
                      if (this._user.email != emailTFController.text) {
                        await this._user.updateEmail(
                              this.emailTFController.text,
                            );
                        await this._user.reload();
                      }
                    }
                  });
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
                    primary: CustomTheme.TrainingPodsRed,
                    onPrimary: Colors.black,
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
          primary: CustomTheme.TrainingPodsRed,
          onPrimary: Colors.black,
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
