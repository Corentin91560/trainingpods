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
                for (var pod in linkedPods) {
                  pod.bleDevice.disconnect();
                  pod.isConnected = false;
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
          child: linkedPods.length > 0
              ? ListView.builder(
                  itemCount: linkedPods.length,
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
                                  linkedPods[index].bleDevice.name != ""
                                      ? linkedPods[index].bleDevice.name
                                      : linkedPods[index].bleDevice.id.toString(),
                                  style: TextStyle(
                                    fontFamily: 'RobotoBold',
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(0, 5, 0, 10),
                                child: Text(
                                  linkedPods[index].bleDevice.id.toString(),
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
                                        primary: linkedPods[index].isConnected
                                            ? CustomTheme.paleRed
                                            : CustomTheme.paleGreen,
                                        textStyle: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      onPressed: () {
                                        if (linkedPods[index].isConnected) {
                                          linkedPods[index]
                                              .bleDevice
                                              .disconnect()
                                              .whenComplete(() {
                                            setState(() {
                                              linkedPods[index].isConnected = false;
                                            });
                                          });
                                        } else {
                                          linkedPods[index]
                                              .bleDevice
                                              .connect()
                                              .whenComplete(() {
                                            linkedPods[index]
                                                .bleDevice
                                                .discoverServices()
                                                .then((value) => linkedPods[index]
                                                        .bleCharacteristic =
                                                    value[0]
                                                        .characteristics[0]);
                                            setState(() {
                                              linkedPods[index].isConnected = true;
                                            });
                                          });
                                        }
                                      },
                                      child: Text(
                                        linkedPods[index].isConnected
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
                                        if (linkedPods[index].isConnected) {
                                          await linkedPods[index].bleDevice.disconnect();
                                          linkedPods[index].isConnected = false;
                                        }
                                        setState(() {
                                          linkedPods.remove(linkedPods[index]);
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
