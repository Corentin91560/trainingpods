import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/widgets/snackbar.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class Authentication {

  static Future<FirebaseApp> initializeFirebase(BuildContext context) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      QuerySnapshot<Map<String, dynamic>> snapshot = await FirebaseFirestore.instance
          .collection('user')
          .limit(1)
          .where('id', isEqualTo: user.uid)
          .get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      if (docs.isNotEmpty) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(
            builder: (context) => HomeScreen(
                user: user),
          ),
        );
      }
    }
    return firebaseApp;
  }

  static Future<User?> signIn({required BuildContext context, required String email, required String password}) async {
    User user;

    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password
      );
      user = userCredential.user!;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user
          ),
        ),
      );

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

  }

  static Future<void> signUp({required BuildContext context, required String email, required String password, required String name}) async {
    User user;
    final FirebaseStorage firebaseStorage = FirebaseStorage.instance;
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email,
              password: password);
      user = userCredential.user!;
      String delimiter = '@';
      int lastIndex = email.indexOf(delimiter);
      final String picture = await firebaseStorage
          .ref('basicUserPicture.jpg')
          .getDownloadURL();


      user.updateProfile(displayName: email.substring(0,lastIndex ), photoURL: picture);
      await FirebaseFirestore.instance.collection("user")
          .add({
            "id" : user.uid
          })
          .then((value) => print(value));

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomeScreen(
            user: user
          ),
        ),
      );
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        CustomSnackBar(
          context,
          const Text('The password provided is too weak.'),
        );
        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        CustomSnackBar(
          context,
          const Text('The account already exists for that email.'),
        );
        print('The account already exists for that email.');
      }
    } catch (e) {
      print(e.toString());
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
      CustomSnackBar(
        context,
        const Text('Error signing out. Try again.'),
      );
    }
  }

  static Future<User?> signInWithFacebook({required BuildContext context}) async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? user;

    try {
      final AccessToken result = (await FacebookAuth.instance.login(permissions: ['email', 'public_profile']));
      final facebookAuthCredential = FacebookAuthProvider.credential(result.token);
      final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(facebookAuthCredential);
      user = userCredential.user!;
      String photoUrl = "${user.photoURL}?height=500&access_token=${result.token}";
      await user.updateProfile(photoURL: photoUrl);


      QuerySnapshot<Map<String, dynamic>> snapshot = await db
          .collection('user')
          .limit(1)
          .where('id', isEqualTo: user.uid)
          .get();
      List<QueryDocumentSnapshot> docs = snapshot.docs;
      if (docs.isEmpty) {
        await db.collection("user")
            .add({
          "id" : user.uid
        }).then((value) => print(value));
      }
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
        Text(e.toString()),
      );
    }
    return user;
  }

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    FirebaseFirestore db = FirebaseFirestore.instance;
    User? user ;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount googleSignInAccount = (await googleSignIn.signIn())!;

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential = await auth.signInWithCredential(credential);
        user = userCredential.user!;

        QuerySnapshot<Map<String, dynamic>> snapshot = await db
            .collection('user')
            .limit(1)
            .where('id', isEqualTo: user.uid)
            .get();
        List<QueryDocumentSnapshot> docs = snapshot.docs;
        if (docs.isEmpty) {
          await db.collection("user")
              .add({
            "id" : user.uid
          }).then((value) => print(value));
        }
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
          Text(e.toString()),
        );
      }

      return user;
    }
  }
}
