import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:smarttelemed/shared/med_devices/device.dart';
import 'package:smarttelemed/shared/med_devices/ble/jumper_spo2_ble_devcie.dart';
import 'package:smarttelemed/shared/med_devices/ble/dummy_ble_device.dart';
import 'package:smarttelemed/shared/med_devices/ble/yuwell_temp_ble_device.dart';
import 'package:smarttelemed/shared/med_devices/ble/yuwell_spo2_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:smarttelemed/shared/med_devices/ble/accuchek_ble_device.dart';
import 'package:smarttelemed/shared/med_devices/ble/yuwell_glucose_ble_device.dart';

class DeviceFactory {
  static Device? createDevice(Map<String, dynamic> json) {
    switch (json['type']) {
      case 'spo2_jumper':
        return JumperSpo2BleDevice.fromJson(json);
      case 'temp_yuwell':
        return YuwellTempBleDevice.fromJson(json);
      case 'accuchek':
        return AccuchekBleDevice.fromJson(json);
      case 'yuwell_glucose':
        return YuwellGlucoseBleDevice.fromJson(json);
      case 'yuwell_spo2':
        return YuwellSpo2BleDevice.fromJson(json);
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
        _device = JumperSpo2BleDevice(
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
      case 'meter+10051687':
        _device = AccuchekBleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'accuchek',
          autoStart: false,
        );
      case 'Yuwell Glucose':
        _device = YuwellGlucoseBleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'yuwell_glucose',
          autoStart: false,
        );
      case 'Yuwell BO-YX110-3058':
        _device = YuwellSpo2BleDevice(
          name: device.name ?? '',
          id: device.deviceId,
          status: 'connected',
          type: 'yuwell_spo2',
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
    print("setBleDevice: ${_device.name}  ${device.name}");
    _device.setBleDevice(device);
    return _device;
  }
}
