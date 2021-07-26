import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

import '../theme.dart';

class FacebookSignInButton extends StatefulWidget {
  @override
  _FacebookSignInButtonState createState() => _FacebookSignInButtonState();
}

class _FacebookSignInButtonState extends State<FacebookSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(bottom: 16.0, top: 8.0),
        child: _isSigningIn
            ? CircularProgressIndicator (
          valueColor: AlwaysStoppedAnimation<Color>(CustomTheme.white),
        )
            : SignInButton(
            Buttons.FacebookNew,
            text: "Continue with Facebook",
            onPressed: () async {
              setState(() {
                _isSigningIn = true;
              });

              User user = (await Authentication.signInWithFacebook(context: context))!;
              setState(() {
                _isSigningIn = false;
              });

              if (user != null) {
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 600),
                      reverseDuration: Duration(milliseconds: 600),
                      type: PageTransitionType.fade,
                      child: HomeScreen(),
                      childCurrent: context.widget),
                );
              }
            }
        )
    );
  }
}