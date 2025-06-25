import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:async';

class YuwellTempBleDevice extends TelemedBleDevice {
  YuwellTempBleDevice({
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

  factory YuwellTempBleDevice.fromJson(Map<String, dynamic> json) {
    return YuwellTempBleDevice(
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
    print('YuwellTempDevice is connected');

    String serviceId = '00001809-0000-1000-8000-00805f9b34fb';
    String notify_uuid = '00002a1c-0000-1000-8000-00805f9b34fb';

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
  }

  @override
  Future<void> onDisconnect() async {
    print('YuwellTempDevice is disconnected');
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      print('YuwellTempDevice cancel subscription');
    }
  }
}
