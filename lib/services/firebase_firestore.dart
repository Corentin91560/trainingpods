import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingpods/models/Scenario.dart';

class firebase_firestore {
  var firestore = FirebaseFirestore.instance;

  firebase_firestore();

  Future<DocumentSnapshot<Map<String, dynamic>>> getCurrentUser(
      String userID) async {
    var user = await firestore.doc("user/$userID").get();
    return user;
  }

  Future<void> createUser(String userID) async {
    DocumentSnapshot<Map<String, dynamic>> snapshot =
        await firestore.doc("user/${userID}").get();
    if (!snapshot.exists) {
      await firestore.doc("user/${userID}").set({"podsCount": 0});

      await firestore.collection('default_scenarios').get().then((event) async {
        if (event.docs.isNotEmpty) {
          for (var doc in event.docs) {
            List<int> actions = List.from(doc.data()['scenario']);
            await firestore.collection("user/$userID/scenarios").add({
              'name': doc.data()["name"],
              'difficulty': doc.data()["difficulty"],
              'creationDate': doc.data()['creationDate'],
              'played': 0,
              'actions': actions,
              'bestTime': 0.0,
              'podsCount': doc.data()['podsCount']
            });
          }
        }
      });
    }
  }

  Future<void> createScenario(Scenario scenarioToCreate, String userID) async {
    await firestore.collection("user/$userID/scenarios").add({
      'name': scenarioToCreate.name,
      'difficulty': scenarioToCreate.difficulty,
      'creationDate': scenarioToCreate.creationDate,
      'played': 0,
      'actions': scenarioToCreate.actions,
      'bestTime': 0.0,
      'podsCount': scenarioToCreate.podsCount
    });
  }

  void updateUser(String userID, int podsCount) {
    firestore.doc('user/${userID}').update({'podsCount': podsCount});
  }

  FirebaseFirestore getInstance() {
    return firestore;
  }
}
