import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:trainingpods/services/facebook_auth.dart';
import 'package:trainingpods/services/firebase_auth.dart';
import 'package:trainingpods/services/firebase_firestore.dart';
import 'package:trainingpods/services/firebase_storage.dart';
import 'package:trainingpods/services/google_auth.dart';
import 'package:trainingpods/widgets/snackbar.dart';

firebase_auth auth = new firebase_auth();
facebook_auth fbAuth = new facebook_auth();
google_auth googleAuth = new google_auth();
firebase_firestore firestore = new firebase_firestore();
firebase_storage storage = new firebase_storage();

void firebaseErrorThrower(FirebaseException e, BuildContext context) {
  switch (e.code) {
    case 'account-exists-with-different-credential':
      snackBarCreator(context, 'The account already exists with a different credential.');
      break;
    case 'user-not-found':
      snackBarCreator(context, 'SError occurred while accessing credentials. Try again.');
      break;
    case 'user-not-found':
      snackBarCreator(context, 'No user found for that email.');
      break;
    case 'wrong-password':
      snackBarCreator(context, 'Wrong password provided for that user.');
      break;
    case 'permission-denied':
      snackBarCreator(context, 'User does not have permission to upload to this reference.');
      break;
    default : {
      snackBarCreator(context, e.toString());
    }
  }
}

void snackBarCreator(BuildContext context, String text) {
  CustomSnackBar(
    context,
    Text(text),
  );
}