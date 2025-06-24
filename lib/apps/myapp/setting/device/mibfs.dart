import 'dart:async';
import 'dart:developer';

import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Mibfs {
  final BluetoothDevice device;

  Mibfs({required this.device});
  StreamController<String> controller = StreamController<String>();

  Stream parse() {
    device.discoverServices();
    device.services.listen((services) {
      services.forEach((scrvice) {
        if (scrvice.uuid.toString() == '0000181b-0000-1000-8000-00805f9b34fb') {
          scrvice.characteristics.forEach((c) {
            if (c.uuid.toString() == '00002a9c-0000-1000-8000-00805f9b34fb') {
              c.setNotifyValue(true);
              c.value.listen((values) {
                String x;

                x = ((((256 * values[12]) + values[11]) / 2) / 100).toString();

                if (values[10] != 0) {
                  controller.add(x);
                }
              });
            }
          });
        }
      });
    });
    return controller.stream;
  }
}
