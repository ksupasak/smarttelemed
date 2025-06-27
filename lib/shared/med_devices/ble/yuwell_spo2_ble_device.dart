import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:async';

class YuwellSpo2BleDevice extends TelemedBleDevice {
  YuwellSpo2BleDevice({
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

  factory YuwellSpo2BleDevice.fromJson(Map<String, dynamic> json) {
    return YuwellSpo2BleDevice(
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
    print('YuwellSpo2Device is connected');

    String serviceId = '0000ffe0-0000-1000-8000-00805f9b34fb';
    String notify_uuid = '0000ffe4-0000-1000-8000-00805f9b34fb';

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
          print('OnValueChange $this.id, $notify_uuid, ${toHex(value)}');
          String hexValue = toHex(value);
          // parse the value

          if (hexValue.substring(0, 2) == 'fe') {
            int heartRate = int.parse(hexValue.substring(8, 10), radix: 16);
            int spo2 = int.parse(hexValue.substring(10, 12), radix: 16);
            print('Spo2: $spo2, HeartRate: $heartRate');
            callback?.call({
              'deviceId': this.id,
              'name': this.name,
              'type': 'spo2',
              'spo2': spo2,
              'pr': heartRate,
            });
          }
        });
  }

  @override
  Future<void> onDisconnect() async {
    // print('Spo2Device is disconnected');
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      print('YuwellSpo2Device cancel subscription');
    }
  }
}
