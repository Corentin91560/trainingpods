import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:page_transition/page_transition.dart';
import 'package:trainingpods/models/TrainingPod.dart';
import 'package:trainingpods/pages/home_page.dart';
import 'package:trainingpods/utils/globals.dart';
import '../../../theme.dart';

class DeviceChooser extends StatefulWidget {
  const DeviceChooser({Key? key}) : super(key: key);

  @override
  _DeviceChooserState createState() => _DeviceChooserState();
}

class _DeviceChooserState extends State<DeviceChooser> {
  final FlutterBlue flutterBlue = FlutterBlue.instance;
  late List<BluetoothDevice> scannedDevicesList;

  @override
  void initState() {
    scannedDevicesList = [];

    flutterBlue.scanResults.listen((List<ScanResult> results) {
      for (ScanResult result in results) {
        _addDeviceTolist(result.device);
      }
    });
    flutterBlue.startScan();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomTheme.whiteAppBarBackground,
        title: Text(
          "Ajout d'un pod",
          style: TextStyle(color: CustomTheme.black),
        ),
        leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: CustomTheme.black,
            ),
            onPressed: () {
              flutterBlue.stopScan();
              Navigator.of(context).pushReplacement(PageTransition(
                  alignment: Alignment.bottomCenter,
                  curve: Curves.easeInOut,
                  duration: Duration(milliseconds: 300),
                  reverseDuration: Duration(milliseconds: 300),
                  type: PageTransitionType.leftToRight,
                  child: HomeScreen(
                    index: 2,
                  ),
                  childCurrent: context.widget));
            }),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: _buildListViewOfDevices(),
        ),
      ),
    );
  }

  _addDeviceTolist(final BluetoothDevice device) {
    if (mounted) {
      if (!scannedDevicesList.contains(device)) {
        setState(() {
          scannedDevicesList.add(device);
        });
      }
    }
  }

  ListView _buildListViewOfDevices() {
    List<Widget> devicesListView = [];
    List<BluetoothDevice> devicesToRemove = [];

    for (var tp in linkedPods) {
      for (var d in scannedDevicesList) {
        if (tp.bleDevice == d) {
          devicesToRemove.add(d);
        }
      }
    }

    scannedDevicesList.removeWhere((element) => devicesToRemove.contains(element));

    for (BluetoothDevice device in scannedDevicesList) {
      devicesListView.add(
        Card(
          child: Container(
            height: 75,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                      child: Text(
                        device.name == '' ? device.id.toString() : device.name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  ElevatedButton(
                    child: Text(
                      'Ajouter',
                      style: TextStyle(color: Colors.black),
                    ),
                    style: ElevatedButton.styleFrom(
                        primary: CustomTheme.paleGreen,
                        onPrimary: CustomTheme.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        )),
                    onPressed: () async {
                      flutterBlue.stopScan();
                      linkedPods.add(TrainingPod(device, false, linkedPods.length + 1));
                      Navigator.of(context).pushReplacement(PageTransition(
                          alignment: Alignment.bottomCenter,
                          curve: Curves.easeInOut,
                          duration: Duration(milliseconds: 300),
                          reverseDuration: Duration(milliseconds: 300),
                          type: PageTransitionType.fade,
                          child: HomeScreen(
                            index: 2,
                          ),
                          childCurrent: context.widget));
                    },
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return ListView(
      padding: const EdgeInsets.all(8),
      children: <Widget>[
        ...devicesListView,
      ],
    );
  }
}