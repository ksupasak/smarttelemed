import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Hc08 {
  final BluetoothDevice device;
  StreamController<String> controller = StreamController<String>();

  Hc08({required this.device});

  // Stream parse() {
  //   device.discoverServices();

  //   device.services.listen((services) {
  //     for (BluetoothService s in services) {
  //       //   print('Service =========== ${s.uuid.toString()}');
  //       if (s.uuid.toString() == "00001809-0000-1000-8000-00805f9b34fb") {
  //         for (BluetoothCharacteristic c in s.characteristics) {
  //           //     print('Char =******=  ${c.uuid.toString()}');
  //           if (c.uuid.toString() == "00002a1c-0000-1000-8000-00805f9b34fb") {
  //             c.setNotifyValue(true);
  //             c.value.listen((values) {
  //               print(values.toString());

  //               if (true) {
  //                 double temp;
  //                 temp = ((values[2] * 256) + values[1]) / 100;
  //                 controller.add('${temp.toString()}');
  //               }
  //             });
  //           }
  //         }
  //       }
  //     }
  //   });

  //   return controller.stream;
  // }

  Stream parse() {
    device.discoverServices();

    device.services.listen((services) {
      for (BluetoothService s in services) {
        //print('Service = ${s.uuid.toString()}');

        if (s.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
          for (BluetoothCharacteristic c in s.characteristics) {
            //print('Char =  ${c.uuid.toString()}');
            if (c.uuid.toString() == "0000ffe1-0000-1000-8000-00805f9b34fb") {
              c.setNotifyValue(true);
              c.value.listen((values) {
                if (values.length > 8) {
                  String temp = '';
                  for (int i = 5; i <= 8; i++) {
                    temp += String.fromCharCode(values[i]);
                  }
                  controller.add('${temp}');
                  // print('Val get = ${temp}');
                }
              });
            }
          }
        }
      }
    });

    return controller.stream;
  }
}
