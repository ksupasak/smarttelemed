import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';

class DummyBleDevice extends TelemedBleDevice {
  DummyBleDevice({
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

  factory DummyBleDevice.fromJson(Map<String, dynamic> json) {
    return DummyBleDevice(
      name: json['name'],
      id: json['id'],
      status: json['status'],
      type: json['type'],
      autoStart: json['autoStart'] ?? false,
    );
  }
}
