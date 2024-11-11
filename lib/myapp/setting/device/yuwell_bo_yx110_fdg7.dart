import 'dart:async';
import 'dart:collection';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Yuwell_BO_YX110_FDC7 {
  final BluetoothDevice device;
  StreamController<Map<String, String>> controller =
      StreamController<Map<String, String>>();

  Yuwell_BO_YX110_FDC7({required this.device});

  Stream parse() {
    device.discoverServices();

    device.services.listen((services) {
      for (BluetoothService s in services) {
        // print('Service ========= ${s.uuid.toString()}');

        if (s.uuid.toString() == "0000ffe0-0000-1000-8000-00805f9b34fb") {
          for (BluetoothCharacteristic c in s.characteristics) {
            //    print('Char =**********=  ${c.uuid.toString()}');
            if (c.uuid.toString() == "0000ffe4-0000-1000-8000-00805f9b34fb") {
              c.setNotifyValue(true);
              c.value.listen((values) {
                print(values);

                if (true) {
                  Map<String, String> val = HashMap();
                  val['spo2'] = values[5].toString();
                  val['pr'] = values[4].toString();
                  controller.add(val);
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
