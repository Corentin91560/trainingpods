import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';

class firebase_storage {

  var storage = FirebaseStorage.instance;

  firebase_storage() {}

  Future<String> getBasicProfilePicture() async {
    var picture = await storage.ref('basicUserPicture.jpg').getDownloadURL();
    return picture;
  }

  Future<String> getUserProfilePicture(String userID) async {
    var picture = await storage.ref('profilePictures/${userID}.png').getDownloadURL();
    return picture;
  }

  Future<void> uploadUserProfilePicture(String userID, File picture) async {
    await storage
        .ref('/profilePictures/${userID}.png')
        .putFile(picture);
  }
}