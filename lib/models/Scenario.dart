import 'package:trainingpods/models/Record.dart';

class Scenario {
  late String? id;
  late String name;
  late List<int> actions;
  late int difficulty;
  late DateTime creationDate;
  late int played;
  late double bestTime;
  late int podsCount;
  late List<Record> records;

  Scenario(String pName, int pDifficulty, DateTime creationDate, int played, List<int> pActions, double bestTime, int pPodsCount, List<Record> pRecords, {String? pId}) {
    if(pId != null) {
      this.id = pId;
    }
    this.name = pName;
    this.difficulty = pDifficulty;
    this.creationDate = creationDate;
    this.played = played;
    this.actions = pActions;
    this.bestTime = bestTime;
    this.podsCount = pPodsCount;
    this.records = pRecords;
  }
}