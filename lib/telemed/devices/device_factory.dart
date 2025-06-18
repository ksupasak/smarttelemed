import 'package:smarttelemed/telemed/devices/telemed_ble_device.dart';
import 'package:smarttelemed/telemed/devices/device.dart';
import 'package:smarttelemed/telemed/devices/spo2_ble_devcie.dart';
import 'package:smarttelemed/telemed/devices/dummy_ble_device.dart';
import 'package:smarttelemed/telemed/devices/yuwell_temp_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';

class DeviceFactory {
  static Device? createDevice(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'spo2_jumper':
        return Spo2BleDevice.fromJson(json);
      case 'temp_yuwell':
        return YuwellTempBleDevice.fromJson(json);
      // Add other types here:
      // case 'bp': return BpDevice.fromJson(json);
      default:
        return DummyBleDevice.fromJson(json);
    }
  }

  static Device? createBleDevice(BleDevice device) {
    TelemedBleDevice? _device = null;

    switch (device.name) {
      case 'My Oximeter':
        _device = Spo2BleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'spo2_jumper',
          autoStart: false,
        );
      case 'Yuwell HT-YHW':
        _device = YuwellTempBleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'temp_yuwell',
          autoStart: false,
        );
      default:
        _device = DummyBleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'dummy',
          autoStart: false,
        );
    }
    if (_device != null) {
      print("setBleDevice: ${_device.name}  ${device.name}");
      _device.setBleDevice(device);
      return _device;
    } else {
      return null;
    }
  }
}
