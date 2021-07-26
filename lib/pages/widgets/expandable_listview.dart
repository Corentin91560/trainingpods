import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:trainingpods/models/Record.dart';
import 'package:trainingpods/models/Scenario.dart';
import 'package:intl/intl.dart';
import 'package:trainingpods/theme.dart';

import 'expandable_container.dart';

class ExpandableListView extends StatefulWidget {
  final Scenario scenario;

  const ExpandableListView({Key? key, required this.scenario})
      : super(key: key);

  @override
  _ExpandableListViewState createState() => new _ExpandableListViewState();
}

class _ExpandableListViewState extends State<ExpandableListView> {
  bool expandFlag = false;

  List<Record> records = [];

  @override
  void initState() {
    records = widget.scenario.records;
    records.sort((a, b) => a.time.compareTo(b.time));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 1.0),
      child: new Column(
        children: <Widget>[
          new Container(
            color: CustomTheme.white,
            padding: new EdgeInsets.symmetric(horizontal: 5.0),
            child: new Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                    width: 30,
                    height: 30,
                    decoration: new BoxDecoration(
                      color: getScenarioColor(),
                      shape: BoxShape.circle,
                    )),
                Spacer(),
                Text(
                  widget.scenario.name,
                  textAlign: TextAlign.center,
                  style: new TextStyle(
                      fontWeight: FontWeight.bold, color: CustomTheme.black),
                ),
                Spacer(),
                IconButton(
                    icon: new Center(
                      child: new Icon(
                        expandFlag
                            ? Icons.keyboard_arrow_up
                            : Icons.keyboard_arrow_down,
                        color: CustomTheme.black,
                        size: 30.0,
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        expandFlag = !expandFlag;
                      });
                    }),
              ],
            ),
          ),
          new ExpandableContainer(
              scenario: widget.scenario,
              expanded: expandFlag,
              child: new ListView.builder(
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.fromLTRB(5, 5, 5, 0),
                    child: new Container(
                      decoration: new BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border:
                              new Border.all(width: 1.0, color: CustomTheme.greyBackground),
                          color: getScenarioColor()),
                      child: new ListTile(
                        title: Row(
                          children: [
                            Spacer(),
                            Text(
                              "${formatTime(records[index].time)}",
                              style: new TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: CustomTheme.black),
                            ),
                            Spacer(),
                            Text(
                              "  Réalisé le ${DateFormat('dd/MM/yyyy').format(records[index].date)}",
                              style: TextStyle(
                                fontSize: 12,
                              ),
                            )
                          ],
                        ),
                        leading: getTrophyIcon(index),
                      ),
                    ),
                  );
                },
                itemCount: widget.scenario.records.length,
              ))
        ],
      ),
    );
  }

  String formatTime(int milliseconds) {
    var secs = milliseconds ~/ 1000;
    var minutes = ((secs % 3600) ~/ 60).toString().padLeft(2, '0');
    var seconds = (secs % 60).toString().padLeft(2, '0');
    var ms = ((milliseconds % 999) % 100).toString().padLeft(2, '0');

    return "$minutes:$seconds:$ms";
  }

  Widget getTrophyIcon(int index) {
    switch (index) {
      case 0:
        return Container(
          width: 30,
          height: 30,
          decoration: new BoxDecoration(
            border: Border.all(color: CustomTheme.gold, width: 2),
            color: CustomTheme.white,
            shape: BoxShape.circle,
          ),
          child: new Icon(
            Icons.emoji_events_outlined,
            color: CustomTheme.gold,
          ),
        );
      case 1:
        return Container(
          width: 30,
          height: 30,
          decoration: new BoxDecoration(
            border: Border.all(color: CustomTheme.silver, width: 2),
            color: CustomTheme.white,
            shape: BoxShape.circle,
          ),
          child: new Icon(
            Icons.emoji_events_outlined,
            color: CustomTheme.silver,
          ),
        );
      case 2:
        return Container(
          width: 30,
          height: 30,
          decoration: new BoxDecoration(
            border: Border.all(color: CustomTheme.bronze, width: 2),
            color: CustomTheme.white,
            shape: BoxShape.circle,
          ),
          child: new Icon(
            Icons.emoji_events_outlined,
            color: CustomTheme.bronze,
          ),
        );
      default:
        {
          return Container(
            width: 1,
          );
        }
    }
  }

  Color getScenarioColor() {
    switch (widget.scenario.difficulty) {
      case 1:
        return CustomTheme.paleGreen;
      case 2:
        return CustomTheme.paleYellow;
      case 3:
        return CustomTheme.paleRed;
      default:
        {
          return CustomTheme.white;
        }
    }
  }
}
