import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class GoogleSignInButton extends StatefulWidget {
  @override
  _GoogleSignInButtonState createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isSigningIn = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: _isSigningIn
          ? CircularProgressIndicator (
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            )
          : SignInButton(
              Buttons.Google,
              text: "Continue with Google",
              onPressed: () async {
                setState(() {
                _isSigningIn = true;
                });
                User user = (await Authentication.signInWithGoogle(context: context))!;
                setState(() {
                  _isSigningIn = false;
                });
                if (user != null) {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (context) => UserInfoScreen(
                        user: user, username: user.displayName!,
                      ),
                    ),
                  );
                }
              }
            )
    );
    }
}