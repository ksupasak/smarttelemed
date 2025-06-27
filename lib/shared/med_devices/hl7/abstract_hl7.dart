import 'package:smarttelemed/shared/med_devices/device.dart';

abstract class AbstractHl7 extends Device {
  AbstractHl7({
    required super.name,
    required super.id,
    required super.type,
    required super.status,
    required super.autoStart,
  });

  @override
  void connect() {
    print('AbstractHl7 is connecting');
  }

  @override
  void onTick() {
    print('AbstractHl7 is ticking');
  }

  @override
  void disconnect() {
    print('AbstractHl7 is disconnecting');
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
