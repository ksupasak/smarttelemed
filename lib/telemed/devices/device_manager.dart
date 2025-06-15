import 'package:smarttelemed/telemed/devices/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttelemed/telemed/devices/device_factory.dart';
import 'dart:convert';

class DeviceManager {
  static final DeviceManager _instance = DeviceManager._internal();
  factory DeviceManager() => _instance;

  DeviceManager._internal();

  List<Device> devices = [];

  void addDevice(Device device) {
    print('Adding device: ${device.id}');
    devices.add(device);
  }

  void removeDevice(Device device) {
    print('Removing device: ${device.id}');
    devices.remove(device);
  }

  List<Device> getDevices() {
    return devices;
  }

  Future<void> load() async {
    List<Device?> loadedDevices = await loadDevices();
    devices = loadedDevices
        .where((device) => device != null)
        .cast<Device>()
        .toList();
  }

  void save() async {
    await saveDevices(devices);
  }

  static const String key = 'saved_devices';

  Future<void> saveDevices(List<Device> devices) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> jsonList = devices
        .map((device) => jsonEncode(device.toJson()))
        .toList();

    print('Saved ${jsonList.length} devices');

    await prefs.setStringList(key, jsonList);
  }

  Future<List<Device?>> loadDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? jsonList = prefs.getStringList(key);
    if (jsonList == null) return [];

    print('Loaded ${jsonList.length} devices');

    return jsonList.map((str) {
      final json = jsonDecode(str);
      Device? device = DeviceFactory.createDevice(json);
      return device;
    }).toList();
  }
}
