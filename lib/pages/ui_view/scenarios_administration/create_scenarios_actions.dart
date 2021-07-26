import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../theme.dart';

class ActionsChooser extends StatefulWidget {
  const ActionsChooser(
      {Key? key, required int podsCount, required List<int> actions})
      : _podsCount = podsCount,
        _actions = actions,
        super(key: key);

  final List<int> _actions;
  final int _podsCount;

  @override
  _ActionsChooserState createState() => _ActionsChooserState();
}

class _ActionsChooserState extends State<ActionsChooser> {
  late int podsCount;
  List<int> actions = [];
  List<Row> pods = [];

  @override
  void initState() {
    this.podsCount = widget._podsCount;
    this.actions = widget._actions;
    for (int i = 0; i < podsCount; i += 2) {
      pods.add(
        Row(
          children: [
            ElevatedButton(
              onPressed: () {
                setState(() {
                  actions.add(i + 1);
                });
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all(CircleBorder()),
                padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                backgroundColor:
                    MaterialStateProperty.all(CustomTheme.whiteBackground),
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed))
                    return CustomTheme.paleGreen;
                }),
              ),
              child: Text(
                (i + 1).toString(),
                style: TextStyle(
                    fontSize: 75,
                    fontFamily: 'Roboto',
                    color: CustomTheme.black),
              ),
            ),
            Spacer(),
            i + 1 < podsCount
                ? ElevatedButton(
                    onPressed: () {
                      setState(() {
                        actions.add(i + 2);
                      });
                    },
                    style: ButtonStyle(
                      shape: MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(EdgeInsets.all(50)),
                      backgroundColor: MaterialStateProperty.all(
                          CustomTheme.whiteBackground),
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return CustomTheme.paleGreen;
                      }),
                    ),
                    child: Text(
                      (i + 2).toString(),
                      style: TextStyle(
                          fontSize: 75,
                          fontFamily: 'Roboto',
                          color: CustomTheme.black),
                    ),
                  )
                : Spacer()
          ],
        ),
      );
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 30, 0),
                  child: Column(
                    children: pods,
                  ),
                ),
                Align(
                  alignment: FractionalOffset.center,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: CustomTheme.whiteBackground,
                    child: IconButton(
                      icon: Icon(
                        Icons.undo_rounded,
                        color: CustomTheme.red,
                      ),
                      onPressed: () {
                        setState(() {
                          if (actions.isNotEmpty) {
                            actions.removeLast();
                          }
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: CustomTheme.paleYellow),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    actionsStringBuilder(),
                    style: TextStyle(fontSize: 12, fontFamily: "RobotoBold"),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 25),
              child: CircleAvatar(
                radius: 50,
                backgroundColor: CustomTheme.paleGreen,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: Icon(
                    Icons.done_outlined,
                    color: CustomTheme.black,
                    size: 50,
                  ),
                  onPressed: () {
                    Navigator.pop(context, actions);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String actionsStringBuilder() {
    String actionsString = "";
    for (var a in actions) {
      actionsString += "$a|";
    }
    return actionsString;
  }
}
