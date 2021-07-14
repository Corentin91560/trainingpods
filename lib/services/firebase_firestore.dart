import 'package:cloud_firestore/cloud_firestore.dart';

class firebase_firestore {

  var firestore = FirebaseFirestore.instance;

  firebase_firestore();

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser(String userID) async {
    var user = await firestore.doc("user/$userID").get();
    return user;
  }

  Future<void> createUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
    await firestore.doc("user/${userID}").get();
    if (!snapshot.exists) {
      await firestore.doc("user/${userID}").set({"podsCount": 0});
    }
  }

  void updateUser(String userID, int podsCount) {
    firestore
        .doc('user/${userID}')
        .update({'podsCount': podsCount});
  }

  FirebaseFirestore getInstance() {
    return firestore;
  }

}