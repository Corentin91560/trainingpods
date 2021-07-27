import 'dart:async';
import 'dart:convert';
import 'package:flutter_blue/flutter_blue.dart';

class TrainingPod {
  late int id;
  late BluetoothDevice bleDevice;
  late bool isConnected;
  late BluetoothCharacteristic? bleCharacteristic;

  TrainingPod(BluetoothDevice pPod, bool pIsConnected, int pID) {
    this.bleDevice = pPod;
    this.isConnected = pIsConnected;
    this.id = pID;
  }

  Future<void> connect() async {
    bleDevice.connect().then((value) => this.isConnected = true);
  }

  Future<void> disconnect() async {
    bleDevice.disconnect().then((value) => this.isConnected = false);
  }

  Future<void> run() async {
    if (bleCharacteristic != null) {
      bool touched = false;
      write(1);
      while (true) {
        List<int> value = await bleCharacteristic!.read();
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
    await bleCharacteristic!.write(utf8.encode(val.toString()));
  }
}
