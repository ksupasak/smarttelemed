import 'dart:collection';
import 'dart:developer';
import 'dart:async';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class AdUa651ble {
  final BluetoothDevice device;
  StreamController<Map<String, String>> controller =
      StreamController<Map<String, String>>();
  AdUa651ble({required this.device});

  Stream parse() {
    device.discoverServices();
    device.services.listen((services) {
      services.forEach((service) {
        print('Service =---->--------> ${service.uuid.toString()}');
        if (service.uuid.toString() == '00001810-0000-1000-8000-00805f9b34fb') {
          service.characteristics.forEach((c) {
            print("-----------222-------> ${c.uuid.toString()}");
          });
        }
        service.characteristics.forEach((c) {
          if (c.uuid.toString() == '00002a35-0000-1000-8000-00805f9b34fb') {
            c.setNotifyValue(true);
            c.value.listen((values) {
              Map<String, String> val = HashMap();
              print(values);
              print(values[1]);
              print(values[3]);
              print(values[7]);
              if (values[1] == 255) {
                val['sys'] = '0';
                val['dia'] = '0';
                val['pul'] = '0';
                val['p'] = values.toString();
                controller.add(val);
              } else {
                val['sys'] = values[1].toString();
                val['dia'] = values[3].toString();
                val['pul'] = values[7].toString();
                val['p'] = values.toString();
                controller.add(val);
              }
            });
          }
        });
      });
    });

    return controller.stream;
  }

// yuwell
  // Stream parse() {
  //   print('เข้า');
  //   device.discoverServices();
  //   device.services.listen((services) {
  //     services.forEach((service) {
  //       print('Service =---->--------> ${service.uuid.toString()}');
  //       if (service.uuid.toString() == '00001810-0000-1000-8000-00805f9b34fb') {
  //         //5
  //         service.characteristics.forEach((c) {
  //           print("-----------222-------> ${c.uuid.toString()}");
  //           service.characteristics.forEach((c) {
  //             if (c.uuid.toString() == '00002a35-0000-1000-8000-00805f9b34fb') {
  //               //1
  //               c.setNotifyValue(true);
  //               c.value.listen((values) {
  //                 Map<String, String> val = HashMap();
  //                 print(values);
  //                 if (true) {
  //                   val['sys'] = values[1].toString();
  //                   val['dia'] = values[3].toString();
  //                   val['pul'] = values[14].toString();
  //                   val['p'] = values.toString();
  //                   controller.add(val);
  //                 }
  //               });
  //             }
  //           });
  //         });
  //       }
  //     });
  //   });

  //   return controller.stream;
  // }
}
