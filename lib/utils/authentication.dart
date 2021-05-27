import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/widgets/snackbar.dart';

class Authentication {

  static Future<FirebaseApp> initializeFirebase(BuildContext context) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User user = FirebaseAuth.instance.currentUser;
    String username;

    if (user != null) {
      await FirebaseFirestore.instance.collection("user")
          .where("email",isEqualTo: user.email.toLowerCase())
          .get()
          .then((QuerySnapshot querySnapshot) {
        querySnapshot.docs.forEach((doc) {
          username = doc["name"];
        });
      });
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
            username: username,
          ),
        ),
      );
    }

    return firebaseApp;
  }

  static Future<User> signIn({BuildContext context, String email, String password}) async {
    User user;
    String username;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user;

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        CustomSnackBar(
          context,
          const Text('No user found for that email.'),
        );
      } else if (e.code == 'wrong-password') {
        CustomSnackBar(
          context,
          const Text('Wrong password provided for that user.'),
        );
      }
    }
    await FirebaseFirestore.instance.collection("user")
        .where("email",isEqualTo: email.toLowerCase())
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        username = doc["name"];
        print(doc["name"]);
      });
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => UserInfoScreen(
          user: user,
          username: username,
        ),
      ),
    );
  }

  static Future<void> signUp({BuildContext context, String email, String password, String name}) async {
    User user;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email,
              password: password);
      user = userCredential.user;

      await FirebaseFirestore.instance.collection("user")
          .add({
            "email" : email,
            "name" : name
          })
          .then((value) => print(value));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => UserInfoScreen(
            user: user,
            username: name,
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomSnackBar(
          context,
          const Text('The password provided is too weak.'),
        );
      } else if (e.code == 'email-already-in-use') {
        CustomSnackBar(
          context,
          const Text('The account already exists for that email.'),
        );
      }
    } catch (e) {
      print(e);
    }

  }

  static Future<void> signOut({BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      CustomSnackBar(
        context,
        const Text('Error signing out. Try again.'),
      );
    }
  }

  static Future<User> signInWithGoogle({BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
            await auth.signInWithCredential(credential);

        user = userCredential.user;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          CustomSnackBar(
            context,
            const Text(
                'The account already exists with a different credential.'),
          );
        } else if (e.code == 'invalid-credential') {
          CustomSnackBar(
            context,
            const Text(
                'SError occurred while accessing credentials. Try again.'),
          );
        }
      } catch (e) {
        CustomSnackBar(
          context,
          Text('error $e'),
        );
      }

      return user;
    }
  }
}
