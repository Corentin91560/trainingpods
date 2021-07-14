import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class google_auth {
  google_auth() {}

  Future<OAuthCredential> signIn() async {
    try {
      var auth = GoogleSignIn();
      var account = await auth.signIn();
      var authentication = await account!.authentication;
      var cred = GoogleAuthProvider.credential(
        accessToken: authentication.accessToken,
        idToken: authentication.idToken,
      );
      return cred;
    } catch(e) {
      return Future.error(e);
    }
  }
}
