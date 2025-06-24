import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

class YuwellGlucoseBleDevice extends TelemedBleDevice {
  YuwellGlucoseBleDevice({
    required String name,
    required String id,
    required String status,
    required String type,
    required bool autoStart,
  }) : super(
         name: name,
         id: id,
         status: status,
         type: type,
         autoStart: autoStart,
       );

  factory YuwellGlucoseBleDevice.fromJson(Map<String, dynamic> json) {
    return YuwellGlucoseBleDevice(
      name: json['name'],
      id: json['id'],
      status: json['status'],
      type: json['type'],
      autoStart: json['autoStart'] ?? false,
    );
  }

  StreamSubscription<Uint8List>? _bleSubscription = null;

  @override
  Future<void> onConnect() async {
    print('YuwellGlucoseBleDevice is connected');

    String serviceId = '00001808-0000-1000-8000-00805f9b34fb';
    String notify_uuid = '00002a18-0000-1000-8000-00805f9b34fb';

    // Subscribe to a characteristic
    UniversalBle.setNotifiable(
      this.id,
      serviceId,
      notify_uuid,
      BleInputProperty.notification,
    );

    // 104  68
    // 06 06 00 e6 07 01 06 0b 12 27 3a c0 11
    //                YY MM DD
    // 91   5B
    // 06 07 00 e6 07 01 06 0c 14 04 33 c0 11

    // Get characteristic updates using stream
    _bleSubscription =
        UniversalBle.characteristicValueStream(this.id, notify_uuid).listen((
          Uint8List value,
        ) {
          print(
            'YuwellGlucoseBleDevice OnValueChange $this.id, $notify_uuid, ${toHex(value)}',
          );
          String hexValue = toHex(value);
          // parse the value

          // if (hexValue.substring(0, 2) == '81' &&
          //     hexValue.substring(4, 6) != '7f') {
          //   int heartRate = int.parse(hexValue.substring(2, 4), radix: 16);
          //   int spo2 = int.parse(hexValue.substring(4, 6), radix: 16);
          //   print('Spo2: $spo2, HeartRate: $heartRate');
          //   onValueChanged?.call({
          //     'deviceId': this.id,
          //     'name': this.name,
          //     'type': 'spo2',
          //     'spo2': spo2,
          //     'pr': heartRate,
          //   });
          // }
        });
    print('YuwellGlucoseBleDevice Subscribed');
  }

  @override
  Future<void> onDisconnect() async {
    print('YuwellGlucoseBleDevice is disconnected');
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      _bleSubscription = null;
      print('YuwellGlucoseBleDevice cancel subscription');
    }
  }
}
