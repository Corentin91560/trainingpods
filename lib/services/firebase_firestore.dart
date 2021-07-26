import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:trainingpods/models/Record.dart';
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

  Future<void> updateScenario(Scenario newScenario, String userID) async {
    await firestore.doc('user/$userID/scenarios/${newScenario.id}').update({
      'name': newScenario.name,
      'difficulty': newScenario.difficulty,
      'creationDate': newScenario.creationDate,
      'played': newScenario.played,
      'actions': newScenario.actions,
      'bestTime': newScenario.bestTime,
      'podsCount': newScenario.podsCount
    });
  }

  void updateUser(String userID, int podsCount) {
    firestore.doc('user/${userID}').update({'podsCount': podsCount});
  }

  Future<List<Scenario>> getScenarios(String userID) async {
    List<Scenario> scenarios = [];
    await FirebaseFirestore.instance
        .collection('user/$userID/scenarios')
        .get()
        .then((scenariosEvent) async {
      if (scenariosEvent.docs.isNotEmpty) {
        for (var doc in scenariosEvent.docs) {
          List<int> actions = List.from(doc.data()['actions']);
          List<Record> records = [];
          await FirebaseFirestore.instance
              .collection('/user/$userID/scenarios/${doc.id}/records')
              .get()
              .then((recordsEvent) {
            for (var record in recordsEvent.docs) {
              records.add(new Record(
                  DateTime.parse(record.data()['date'].toDate().toString()),
                  record.data()['time']));
            }
          });
          scenarios.add(new Scenario(
              doc.data()['name'],
              doc.data()['difficulty'],
              DateTime.parse(doc.data()['creationDate'].toDate().toString()),
              doc.data()['played'],
              actions,
              doc.data()['bestTime'],
              doc.data()['podsCount'],
              records,
              pId: doc.id));
        }
      }
    });
    return scenarios;
  }

  Future<void> createRecord(String userID, Scenario scenario, Record recordToAdd) async {

    await firestore.doc("user/$userID/scenarios/${scenario.id}").update({"played" : FieldValue.increment(1)});
    await firestore.collection("user/$userID/scenarios/${scenario.id}/records").add({
      'date': recordToAdd.date,
      'time': recordToAdd.time,
    });
  }

  Future<void> deleteScenario(Scenario scenarioToDelete, String userID) async {
    await firestore
        .doc("user/$userID/scenarios/${scenarioToDelete.id}")
        .delete();
  }

  FirebaseFirestore getInstance() {
    return firestore;
  }
}
