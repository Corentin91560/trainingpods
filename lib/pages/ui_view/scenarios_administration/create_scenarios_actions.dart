import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ActionsChooser extends StatefulWidget {
  const ActionsChooser({Key? key, required int podsCount})
      : _podsCount = podsCount,
        super(key: key);

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
                backgroundColor: MaterialStateProperty.all(Colors.grey[400]),
                // <-- Button color
                overlayColor:
                    MaterialStateProperty.resolveWith<Color?>((states) {
                  if (states.contains(MaterialState.pressed))
                    return Colors.greenAccent[200]; // <-- Splash color
                }),
              ),
              child: Text((i + 1).toString(),
                  style: TextStyle(
                      fontSize: 75, fontFamily: 'Roboto', color: Colors.black)),
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
                      backgroundColor:
                          MaterialStateProperty.all(Colors.grey[400]),
                      // <-- Button color
                      overlayColor:
                          MaterialStateProperty.resolveWith<Color?>((states) {
                        if (states.contains(MaterialState.pressed))
                          return Colors.greenAccent[200]; // <-- Splash color
                      }),
                    ),
                    child: Text((i + 2).toString(),
                        style: TextStyle(
                            fontSize: 75,
                            fontFamily: 'Roboto',
                            color: Colors.black)),
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
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 0),
                  child: Column(
                    children: pods,
                  ),
                ),
                Align(
                  alignment: FractionalOffset.center,
                  child: CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.grey,
                    child: IconButton(
                      icon: Icon(
                        Icons.undo_rounded,
                        color: Colors.redAccent,
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
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Colors.grey[300]),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        actionsStringBuilder(),
                        style:
                            TextStyle(fontSize: 16, fontFamily: "RobotoBold"),
                        maxLines: 4,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 0, 25, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.redAccent,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.close_outlined,
                        color: Colors.black,
                        size: 45,
                      ),
                      onPressed: () {
                        Navigator.pop(context, [-1]);
                      },
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 0, 0),
                  child: CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.greenAccent,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: Icon(
                        Icons.done_outlined,
                        color: Colors.black,
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
