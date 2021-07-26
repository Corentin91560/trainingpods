import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/utils/globals.dart';
import '../../../theme.dart';
import 'device_chooser.dart';

class PodsSettingsView extends StatefulWidget {
  const PodsSettingsView({Key? key}) : super(key: key);

  @override
  _PodsSettingsViewState createState() => _PodsSettingsViewState();
}

class _PodsSettingsViewState extends State<PodsSettingsView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.whiteAppBarBackground,
        title: Text(
          "Paramètres des pods",
          style: TextStyle(color: CustomTheme.black),
        ),
        automaticallyImplyLeading: false,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () {
                for (var tp in pods) {
                  tp.pod.disconnect();
                  tp.isConnected = false;
                }
                Navigator.pushReplacement(
                  context,
                  PageTransition(
                      alignment: Alignment.bottomCenter,
                      curve: Curves.easeInOut,
                      duration: Duration(milliseconds: 300),
                      reverseDuration: Duration(milliseconds: 300),
                      type: PageTransitionType.rightToLeft,
                      child: DeviceChooser(),
                      childCurrent: context.widget),
                );
              },
              child: Icon(
                Icons.add,
                size: 26.0,
                color: CustomTheme.black,
              ),
            ),
          ),
        ],
      ),
      backgroundColor: CustomTheme.whiteBackground,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: pods.length > 0
              ? ListView.builder(
                  itemCount: pods.length,
                  itemBuilder: (context, index) {
                    return Card(
                      child: Container(
                        height: MediaQuery.of(context).size.height / 7,
                        decoration: new BoxDecoration(
                          borderRadius: BorderRadius.circular(50.0),
                          color: CustomTheme.white,
                        ),
                        child: ListTile(
                          onTap: () async {},
                          title: Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
                                child: Text(
                                  pods[index].pod.name != ""
                                      ? pods[index].pod.name
                                      : pods[index].pod.id.toString(),
                                  style: TextStyle(
                                    fontFamily: 'RobotoBold',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: Text(
                                  pods[index].pod.id.toString(),
                                  style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontSize: 12,
                                      fontWeight: FontWeight.w300),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        shape: new RoundedRectangleBorder(
                                          borderRadius:
                                              new BorderRadius.circular(30.0),
                                        ),
                                        primary: pods[index].isConnected
                                            ? CustomTheme.paleRed
                                            : CustomTheme.paleGreen,
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (pods[index].isConnected) {
                                          pods[index]
                                              .pod
                                              .disconnect()
                                              .whenComplete(() {
                                            setState(() {
                                              pods[index].isConnected = false;
                                            });
                                          });
                                        } else {
                                          pods[index]
                                              .pod
                                              .connect()
                                              .whenComplete(() {
                                            pods[index]
                                                .pod
                                                .discoverServices()
                                                .then((value) => pods[index]
                                                        .characteristic =
                                                    value[0]
                                                        .characteristics[0]);
                                            setState(() {
                                              pods[index].isConnected = true;
                                            });
                                          });
                                        }
                                      },
                                      child: Text(
                                        pods[index].isConnected
                                            ? "Deconnecter"
                                            : "Connecter",
                                        style: TextStyle(
                                            fontFamily: 'RobotoBold',
                                            fontSize: 12,
                                            color: CustomTheme.black),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: GestureDetector(
                                      onTap: () async {
                                        if (pods[index].isConnected) {
                                          await pods[index].pod.disconnect();
                                          pods[index].isConnected = false;
                                        }
                                        setState(() {
                                          pods.remove(pods[index]);
                                        });
                                      },
                                      child: Icon(
                                        Icons.highlight_off_outlined,
                                        color: CustomTheme.red,
                                        size: 35,
                                      ),
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  })
              : Center(
                  child: ElevatedButton(
                    child: Text(
                      "Ajouter un pod",
                      style: TextStyle(
                        color: CustomTheme.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(30.0),
                      ),
                      primary: CustomTheme.paleGreen,
                      padding:
                          EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      textStyle: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        PageTransition(
                            alignment: Alignment.bottomCenter,
                            curve: Curves.easeInOut,
                            duration: Duration(milliseconds: 300),
                            reverseDuration: Duration(milliseconds: 300),
                            type: PageTransitionType.rightToLeft,
                            child: DeviceChooser(),
                            childCurrent: context.widget),
                      );
                    },
                  ),
                ),
        ),
      ),
    );
  }
}
