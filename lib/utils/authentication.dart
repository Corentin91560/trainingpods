import 'dart:io';
import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/pages/login_page.dart';
import 'package:trainingpods/widgets/snackbar.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'globals.dart';

class Authentication {
  static Future<FirebaseApp> initializeFirebase(BuildContext context) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();
    User? user = auth.getCurrentUser();

    if (user != null) {
      var snapshot = await firestore.getCurrentUser(user.uid);
      if (snapshot.exists) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(user: user),
          ),
        );
      }
    }
    return firebaseApp;
  }

  static Future<User?> signIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    User user;

    try {
      UserCredential userCredential =
          await auth.signInWithEmailAndPassword(email, password);
      user = userCredential.user!;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(user: user),
        ),
      );
    } on FirebaseAuthException catch (e) {
      firebaseErrorThrower(e, context);
    }
  }

  static Future<void> signUp(
      {required BuildContext context,
      required String email,
      required String password,
      required String name}) async {
    User user;
    try {
      print("DEBUG ");
      UserCredential userCredential =
          await auth.signUpWithEmailAndPassword(email, password);
      user = userCredential.user!;

      String delimiter = '@';
      int lastIndex = email.indexOf(delimiter);
      final String picture = await storage.getBasicProfilePicture();

      user.updateProfile(
          displayName: email.substring(0, lastIndex), photoURL: picture);

      await firestore.createUser(user.uid);

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => LoginPage(),
        ),
      );
    } on FirebaseAuthException catch (e) {
      firebaseErrorThrower(e, context);
    } catch (e) {
      snackBarCreator(context, e.toString());
    }
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {
      if (!kIsWeb) {
        await googleSignIn.signOut();
      }
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      snackBarCreator(context, 'Error signing out. Try again.');
    }
  }

  static Future<User?> signInWithFacebook(
      {required BuildContext context}) async {
    User? user;

    try {
      final AccessToken result = await fbAuth.login();
      final facebookAuthCredential = fbAuth.getCredential(result.token);
      final UserCredential userCredential =
          await auth.signInWithCredentials(facebookAuthCredential);
      user = userCredential.user!;
      String photoURL = "";

      try {
        photoURL = await storage.getUserProfilePicture(user.uid);
        await user.updateProfile(photoURL: photoURL);
      } catch (e) {
        photoURL =
            "${user.photoURL}?height=500&access_token=${result.token}"; // Nouvelle façon d'accéder aux photos FB (pas encore mis à jour par Firebase)
        File photoFile = await urlToFile(photoURL);
        storage.uploadUserProfilePicture(user.uid, photoFile);
        await user.updateProfile(photoURL: photoURL);
      }
      await firestore.createUser(user.uid);
    } on FirebaseAuthException catch (e) {
      firebaseErrorThrower(e, context);
    } catch (e) {
      snackBarCreator(context, e.toString());
    }
    return user;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    User? user;
    try {
      var credentials = await googleAuth.signIn();
      final UserCredential userCredential =
          await auth.signInWithCredentials(credentials);
      user = userCredential.user!;

      await firestore.createUser(user.uid);
    } on FirebaseAuthException catch (e) {
      firebaseErrorThrower(e, context);
    } catch (e) {
      snackBarCreator(context, e.toString());
    }
    return user;
  }

  static Future<File> urlToFile(String imageUrl) async {
    var rng = new Random();
    Directory tempDir = await getTemporaryDirectory();
    String tempPath = tempDir.path;
    File file = new File('$tempPath' + (rng.nextInt(100)).toString() + '.jpeg');
    http.Response response = await http.get(Uri.parse(imageUrl));
    await file.writeAsBytes(response.bodyBytes);
    return file;
  }

}
