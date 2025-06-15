import 'package:smarttelemed/telemed/devices/telemed_ble_device.dart';
import 'package:smarttelemed/telemed/devices/device.dart';
import 'package:smarttelemed/telemed/devices/spo2_ble_devcie.dart';
import 'package:universal_ble/universal_ble.dart';

class DeviceFactory {
  static Device? createDevice(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'spo2':
        return Spo2BleDevice.fromJson(json);
      // Add other types here:
      // case 'bp': return BpDevice.fromJson(json);
      default:
        return null;
    }
  }

  static Device? createBleDevice(BleDevice device) {
    switch (device.name) {
      case 'Spo2':
        return Spo2BleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'spo2',
          autoStart: false,
        );
      default:
        return Spo2BleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'spo2',
          autoStart: false,
        );
        ;
    }
  }
}
