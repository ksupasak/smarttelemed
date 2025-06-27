import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:async';

class JumperSpo2BleDevice extends TelemedBleDevice {
  JumperSpo2BleDevice({
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

  factory JumperSpo2BleDevice.fromJson(Map<String, dynamic> json) {
    return JumperSpo2BleDevice(
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
    print('Spo2Device is connected');

    String serviceId = 'cdeacb80-5235-4c07-8846-93a37ee6b86d';
    String notify_uuid = 'cdeacb81-5235-4c07-8846-93a37ee6b86d';

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

          if (hexValue.substring(0, 2) == '81' &&
              hexValue.substring(4, 6) != '7f') {
            int heartRate = int.parse(hexValue.substring(2, 4), radix: 16);
            int spo2 = int.parse(hexValue.substring(4, 6), radix: 16);
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
      print('Spo2Device cancel subscription');
    }
  }
}
