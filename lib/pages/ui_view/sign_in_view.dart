import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/pages/ui_view/sign_up_view.dart';
import 'package:trainingpods/pages/widgets/beautiful_divider.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:trainingpods/utils/globals.dart';
import 'package:trainingpods/widgets/facebook_sign_in_button.dart';
import 'package:trainingpods/widgets/google_sign_in_button.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: CustomTheme.whiteAppBarBackground,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.all(15),
                        child: Image.asset('assets/img/logo_small.png'),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      "Connexion",
                      style: TextStyle(
                          fontFamily: 'RobotoBold',
                          fontSize: 35,
                          color: CustomTheme.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  BeautifulDivider(),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: FacebookSignInButton(),
                  ),
                  GoogleSignInButton(),
                  BeautifulDivider(text: "Or"),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      controller: loginEmailController,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.next,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomTheme.paleGreen, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Email",
                          fillColor: CustomTheme.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      obscureText: true,
                      controller: loginPasswordController,
                      textAlign: TextAlign.center,
                      textInputAction: TextInputAction.unspecified,
                      decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                                color: CustomTheme.paleGreen, width: 2.0),
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                          filled: true,
                          hintStyle: TextStyle(color: Colors.grey[800]),
                          hintText: "Mot de passe",
                          fillColor: CustomTheme.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Pas encore de compte ? "),
                        TextButton(
                          style:
                              TextButton.styleFrom(primary: CustomTheme.black),
                          onPressed: () {
                            Navigator.push(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  type: PageTransitionType.rightToLeft,
                                  child: SignUp(),
                                  childCurrent: context.widget),
                            );
                          },
                          child: Text(
                            "S'inscrire",
                            style: TextStyle(color: CustomTheme.green),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 25),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (checkFields()) {
                          Authentication.signIn(
                              context: context,
                              email: loginEmailController.text,
                              password: loginPasswordController.text);
                        }
                      },
                      child: Text(
                        "Se connecter",
                        style: TextStyle(color: CustomTheme.black),
                      ),
                      style: ElevatedButton.styleFrom(
                          shape: new RoundedRectangleBorder(
                            borderRadius: new BorderRadius.circular(30.0),
                          ),
                          primary: CustomTheme.paleGreen,
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          textStyle: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          )),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  bool checkFields() {
    if (loginEmailController.text != "" && loginPasswordController.text != "") {
      return true;
    } else {
      snackBarCreator(context, "Certains champs sont vides");
      return false;
    }
  }
}
