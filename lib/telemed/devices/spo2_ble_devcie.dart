import 'package:smarttelemed/telemed/devices/telemed_ble_device.dart';

class Spo2BleDevice extends TelemedBleDevice {
  Spo2BleDevice({
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

  factory Spo2BleDevice.fromJson(Map<String, dynamic> json) {
    return Spo2BleDevice(
      name: json['name'],
      id: json['id'],
      status: json['status'],
      type: json['type'],
      autoStart: json['autoStart'] ?? false,
    );
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'status': status,
    'type': type,
    'autoStart': autoStart,
  };
}
