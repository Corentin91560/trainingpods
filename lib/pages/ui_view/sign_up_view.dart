import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/pages/widgets/beautiful_divider.dart';
import 'package:trainingpods/theme.dart';
import 'package:trainingpods/utils/authentication.dart';
import 'package:trainingpods/utils/globals.dart';
import 'package:trainingpods/widgets/facebook_sign_in_button.dart';
import 'package:trainingpods/widgets/google_sign_in_button.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController =
  TextEditingController();
  TextEditingController signupNameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).requestFocus(new FocusNode());
          },
          child: Container(
            height: MediaQuery
                .of(context)
                .size
                .height,
            width: MediaQuery
                .of(context)
                .size
                .width,
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
                      "Inscription",
                      style: TextStyle(
                          fontFamily: 'RobotoBold',
                          fontSize: 35,
                          color: CustomTheme.black),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  BeautifulDivider(),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      controller: signupNameController,
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
                          hintText: "Nom",
                          fillColor: CustomTheme.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      controller: signupEmailController,
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
                      controller: signupPasswordController,
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
                    padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                    child: TextField(
                      controller: signupConfirmPasswordController,
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
                          hintText: "Validation mot de passe",
                          fillColor: CustomTheme.white),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Vous possédez déjà un compte ? "),
                        TextButton(
                          style:
                          TextButton.styleFrom(primary: CustomTheme.black),
                          onPressed: () {
                            Navigator.pop(
                              context,
                              PageTransition(
                                  alignment: Alignment.bottomCenter,
                                  curve: Curves.easeInOut,
                                  duration: Duration(milliseconds: 300),
                                  reverseDuration: Duration(milliseconds: 300),
                                  type: PageTransitionType.leftToRight,
                                  child: SignUp(),
                                  childCurrent: context.widget),
                            );
                          },
                          child: Text(
                            "Se connecter",
                            style: TextStyle(color: CustomTheme.green),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50),
                    child: ElevatedButton(
                      onPressed: () async {
                        if (checkFields()) {
                          Authentication.signUp(
                              context: context,
                              email: signupEmailController.text,
                              password: signupPasswordController.text,
                              name: signupNameController.text);
                        }
                      },
                      child: Text(
                        "S'inscrire",
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
    if (signupPasswordController.text ==
        signupConfirmPasswordController.text &&
        signupNameController.text != "" &&
        signupEmailController.text != "" &&
        signupPasswordController.text != "" &&
        signupConfirmPasswordController.text != "") {
      return true;
    } else {
      if (signupNameController.text == '' ||
          signupEmailController.text == '') {
        snackBarCreator(
            context, "Certains champs sont vides");
      } else {
        snackBarCreator(context,
            "Les mots de passes ne correspondent pas");
      }
      return false;
    }
  }
}
