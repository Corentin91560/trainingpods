import 'package:firebase_auth/firebase_auth.dart';

class firebase_auth {
  var auth = FirebaseAuth.instance;

  firebase_auth() {}

  User? getCurrentUser() {
    return FirebaseAuth.instance.currentUser;
  }

  Future<UserCredential> signInWithEmailAndPassword(
      String email, String password) async {
    var cred =
        await auth.signInWithEmailAndPassword(email: email, password: password);
    return cred;
  }

  Future<UserCredential> signUpWithEmailAndPassword(String email, String password) async {
    var cred = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: email, password: password);
    return cred;
  }

  Future<UserCredential> signInWithCredentials(
      OAuthCredential credentials) async {
    var cred = await FirebaseAuth.instance.signInWithCredential(credentials);
    return cred;
  }

  FirebaseAuth getInstance() {
    return auth;
  }
}
