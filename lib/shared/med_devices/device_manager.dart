import 'package:smarttelemed/apps/station/widget_decorate/WidgetDecorate.dart';
import 'package:smarttelemed/shared/med_devices/device.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smarttelemed/shared/med_devices/device_factory.dart';
import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'dart:convert';
import 'package:universal_ble/universal_ble.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:isolate';
import 'package:smarttelemed/shared/med_devices/hl7/aquaris_hl7.dart';

class DeviceManager {
  // Private constructor
  DeviceManager._internal();

  // Singleton instance
  static final DeviceManager _instance = DeviceManager._internal();

  // Public getter for the singleton instance
  static DeviceManager get instance => _instance;

  // Private fields
  final List<Device> _devices = [];
  bool _isStarted = false;
  void Function(Map<String, dynamic>)? _onValueChanged;

  // Constants
  static const String _key = 'saved_devices';

  // Getters
  List<Device> get devices => List.unmodifiable(_devices);
  bool get isStarted => _isStarted;
  bool get hasDevices => _devices.isNotEmpty;

  AquarisHl7? hl7;

  // Device management methods
  void addDevice(Device device) {
    if (!_devices.any((d) => d.id == device.id)) {
      print('Adding device: ${device.id}');
      _devices.add(device);
      _saveDevices();
    } else {
      print('Device ${device.id} already exists');
    }
  }

  void removeDevice(Device device) {
    print('Removing device: ${device.id}');
    _devices.removeWhere((d) => d.id == device.id);
    _saveDevices();
  }

  void removeDeviceById(String deviceId) {
    print('Removing device by ID: $deviceId');
    _devices.removeWhere((d) => d.id == deviceId);
    _saveDevices();
  }

  Device? getDeviceById(String deviceId) {
    try {
      return _devices.firstWhere((d) => d.id == deviceId);
    } catch (e) {
      return null;
    }
  }

  List<Device> getDevicesByType(String type) {
    return _devices.where((d) => d.type == type).toList();
  }

  // Persistence methods
  Future<void> load() async {
    stop();
    List<Device?> loadedDevices = await _loadDevices();
    _devices.clear();
    _devices.addAll(
      loadedDevices.where((device) => device != null).cast<Device>(),
    );
    print('Loaded ${_devices.length} devices');
  }

  Future<void> save() async {
    await _saveDevices();
  }

  Future<void> _saveDevices() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String> jsonList = _devices
          .map((device) => jsonEncode(device.toJson()))
          .toList();

      print('Saving ${jsonList.length} devices');
      await prefs.setStringList(_key, jsonList);
    } catch (e) {
      print('Error saving devices: $e');
    }
  }

  Future<List<Device?>> _loadDevices() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? jsonList = prefs.getStringList(_key);
      if (jsonList == null) return [];

      print('Loading ${jsonList.length} devices');

      return jsonList.map((str) {
        try {
          final json = jsonDecode(str);
          Device? device = DeviceFactory.createDevice(json);
          print('Loaded device: ${device?.name} ${device?.id} ${device?.type}');
          return device;
        } catch (e) {
          print('Error loading device from JSON: $e');
          return null;
        }
      }).toList();
    } catch (e) {
      print('Error loading devices: $e');
      return [];
    }
  }

  // Connection management
  void start() {
    if (_isStarted) {
      print('DeviceManager already started');
      return;
    }

    hl7 = AquarisHl7(
      name: 'Aquaris HL7',
      id: 'aquaris_hl7',
      status: 'disconnected',
      type: 'hl7',
      autoStart: true,
    );
    hl7?.setCallback(onValueChanged);
    hl7?.connect();

    print('Starting DeviceManager');
    _isStarted = true;

    for (Device device in _devices) {
      if (device is TelemedBleDevice) {
        device.setCallback(onValueChanged);

        // Isolate.spawn(device.connect, null);
        print("Connect ... ${device.name} ");
        device.connect();
      }
    }
  }

  void stop() {
    if (!_isStarted) {
      print('DeviceManager already stopped');
      return;
    }

    print('****Stopping DeviceManager');
    _isStarted = false;

    for (Device device in _devices) {
      if (device is TelemedBleDevice) {
        device.disconnect();
      }
    }
  }

  void restart() {
    print('Restarting DeviceManager');
    stop();
    start();
  }

  // Callback management
  void setOnValueChanged(void Function(Map<String, dynamic>)? callback) {
    _onValueChanged = callback;

    // Update existing devices with new callback
    for (Device device in _devices) {
      if (device is TelemedBleDevice) {
        device.setCallback(onValueChanged);
      }
    }
  }

  void onValueChanged(Map<String, dynamic> values) {
    print('Device Manger onValueChanged : $values');
    if (_onValueChanged != null) {
      _onValueChanged!(values);
    }
  }

  // Utility methods
  void clearAllDevices() {
    print('Clearing all devices');
    stop();
    _devices.clear();
    _saveDevices();
  }

  bool hasConnectedDevices() {
    return _devices.isNotEmpty;
  }

  List<Device> getConnectedDevices() {
    return _devices.where((device) => device is TelemedBleDevice).toList();
  }

  // Debug methods
  void printDeviceStatus() {
    print('DeviceManager Status:');
    print('  Started: $_isStarted');
    print('  Total devices: ${_devices.length}');
    print('  BLE devices: ${getConnectedDevices().length}');

    for (Device device in _devices) {
      if (device is TelemedBleDevice) {
        print('  - ${device.name} (${device.id}): BLE Device');
      } else {
        print('  - ${device.name} (${device.id}): ${device.type}');
      }
    }
  }
}
