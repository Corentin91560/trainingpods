class Scenario {
  late String name;
  late List<int> actions;
  late int difficulty;
  late DateTime creationDate;
  late int played;
  late double bestTime;
  late int podsCount;

  Scenario(String pName, int pDifficulty, DateTime creationDate, int played, List<int> pActions, double bestTime, int pPodsCount) {
    this.name = pName;
    this.difficulty = pDifficulty;
    this.creationDate = creationDate;
    this.played = played;
    this.actions = pActions;
    this.bestTime = bestTime;
    this.podsCount = pPodsCount;
  }
}