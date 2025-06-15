import 'package:smarttelemed/telemed/devices/device.dart';

abstract class TelemedBleDevice extends Device {
  TelemedBleDevice({
    required super.name,
    required super.id,
    required super.type,
    required super.status,
    required super.autoStart,
  });

  @override
  void connect() {
    // TODO: implement connect
  }
}
