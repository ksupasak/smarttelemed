import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class Yuwell_HT_YHW {
  final BluetoothDevice device;
  StreamController<String> controller = StreamController<String>();

  Yuwell_HT_YHW({required this.device});

  Stream parse() {
    device.discoverServices();

    device.services.listen((services) {
      for (BluetoothService s in services) {
        //   print('Service =========== ${s.uuid.toString()}');
        if (s.uuid.toString() == "00001809-0000-1000-8000-00805f9b34fb") {
          for (BluetoothCharacteristic c in s.characteristics) {
            //     print('Char =******=  ${c.uuid.toString()}');
            if (c.uuid.toString() == "00002a1c-0000-1000-8000-00805f9b34fb") {
              c.setNotifyValue(true);
              c.value.listen((values) {
                print(values.toString());

                if (true) {
                  double temp;
                  temp = ((values[2] * 256) + values[1]) / 100;
                  controller.add('${temp.toString()}');
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
