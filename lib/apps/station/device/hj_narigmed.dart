import 'dart:async';
import 'dart:collection';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class HjNarigmed {
  final BluetoothDevice device;
  StreamController<Map<String, String>> controller =
      StreamController<Map<String, String>>();

  HjNarigmed({required this.device});
// yuwell
  // Stream parse() {
  //   device.discoverServices();

  //   device.services.listen((services) {
  //     for (BluetoothService s in services) {
  //       // print('Service ========= ${s.uuid.toString()}');

  //       if (s.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
  //         for (BluetoothCharacteristic c in s.characteristics) {
  //           //    print('Char =**********=  ${c.uuid.toString()}');
  //           if (c.uuid.toString() == "0000ffe4-0000-1000-8000-00805f9b34fb") {
  //             c.setNotifyValue(true);
  //             c.value.listen((values) {
  //               print(values);

  //               if (true) {
  //                 Map<String, String> val = HashMap();
  //                 val['spo2'] = values[5].toString();
  //                 val['pr'] = values[4].toString();
  //                 controller.add(val);
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
        print('Service ========= ${s.uuid.toString()}');

        if (s.uuid.toString() == "0000fff0-0000-1000-8000-00805f9b34fb") {
          //0000ffe0-0000-1000-8000-00805f9b34fb
          for (BluetoothCharacteristic c in s.characteristics) {
            //print('Char =  ${c.uuid.toString()}');
            if (c.uuid.toString() == "0000fff1-0000-1000-8000-00805f9b34fb") {
              c.setNotifyValue(true);
              c.value.listen((values) {
                if (values.length > 2 && values[1] == 11) {
                  //  print("Val get" + values.toString());

                  if (values[3] != 0) {
                    Map<String, String> val = HashMap();
                    val['spo2'] = values[3].toString();
                    val['pr'] = values[4].toString();
                    controller.add(val);
                  }
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
