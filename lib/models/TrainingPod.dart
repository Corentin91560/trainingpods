import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';

class TrainingPod {
  late int id;
  late BluetoothDevice pod;
  late bool isConnected;
  late BluetoothCharacteristic? characteristic;

  TrainingPod(BluetoothDevice pPod, bool pIsConnected, int pID) {
    this.pod = pPod;
    this.isConnected = pIsConnected;
    this.id = pID;
  }

  Future<void> connect() async {
    pod.connect().then((value) => this.isConnected = true);
  }

  Future<void> disconnect() async {
    pod.disconnect().then((value) => this.isConnected = false);
  }

  Future<void> run() async {
    if (characteristic != null) {
      bool touched = false;
      write(1);
      while (true) {
        List<int> value = await characteristic!.read();
        if (value[0] == 2) {
          touched = true;
        }
        if (touched) {
          break;
        }
        await new Future.delayed(const Duration(milliseconds: 100));
      }
      write(0);
    }
  }

  Future<void> write(int val) async {
    await characteristic!.write(utf8.encode(val.toString()));
  }
}
