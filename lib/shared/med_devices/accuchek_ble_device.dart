import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:convert';
import 'dart:async';

class AccuchekBleDevice extends TelemedBleDevice {
  AccuchekBleDevice({
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

  factory AccuchekBleDevice.fromJson(Map<String, dynamic> json) {
    return AccuchekBleDevice(
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
    print('AccuchekBleDevice is connected');

    String serviceId = '00001808-0000-1000-8000-00805f9b34fb';
    String notify_uuid = '00002a18-0000-1000-8000-00805f9b34fb';
    String notify_write = '00002a52-0000-1000-8000-00805f9b34fb';

    // Subscribe to a characteristic
    UniversalBle.setNotifiable(
      this.id,
      serviceId,
      notify_uuid,
      BleInputProperty.notification,
    );
    // Get characteristic updates using stream
    _bleSubscription =
        UniversalBle.characteristicValueStream(this.id, notify_uuid).listen((
          Uint8List value,
        ) {
          print(
            'AccuchekBleDevice OnValueChange $this.id, $notify_uuid, ${toHex(value)}',
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

    UniversalBle.characteristicValueStream(this.id, notify_write).listen((
      Uint8List value,
    ) {
      print(
        'AccuchekBleDevice OnValueChangvve $this.id, $notify_write, ${toHex(value)}',
      );
    });
    await Future.delayed(Duration(seconds: 2));

    UniversalBle.writeValue(
      this.id,
      serviceId,
      "00002a52-0000-1000-8000-00805f9b34fb",
      Uint8List.fromList([0x01, 0x01]),
      BleOutputProperty.withResponse,
    );

    print('AccuchekBleDevice Subscribed');
  }

  @override
  Future<void> onDisconnect() async {
    print('AccuchekBleDevice is disconnected');
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      _bleSubscription = null;

      print('AccuchekBleDevice cancel subscription');
    }
  }
}
