import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';

class facebook_auth {
  var auth = FacebookAuth.instance;

  facebook_auth() {}

  Future<AccessToken> login() async {
    var token = await FacebookAuth.instance.login(permissions: ['email', 'public_profile']);
    return token;
  }

  OAuthCredential getCredential(String token) {
    return FacebookAuthProvider.credential(token);
  }


}