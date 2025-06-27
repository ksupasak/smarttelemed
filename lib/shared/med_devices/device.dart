import 'package:universal_ble/universal_ble.dart';

abstract class Device {
  String name;
  String id;
  String type;
  String status;
  bool autoStart;

  Device({
    required this.name,
    required this.id,
    required this.type,
    required this.status,
    this.autoStart = false,
  });

  void connect();
  void disconnect();
  void onTick();

  void Function(Map<String, dynamic>)? callback;

  Map<String, dynamic> toJson();
  void setCallback(void Function(Map<String, dynamic>)? callback) {
    this.callback = callback;
  }
}
