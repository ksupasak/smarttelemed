import 'package:smarttelemed/shared/med_devices/ble/abstract_ble_device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';
import 'dart:async';

class YuwellGlucoseBleDevice extends TelemedBleDevice {
  YuwellGlucoseBleDevice({
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

  factory YuwellGlucoseBleDevice.fromJson(Map<String, dynamic> json) {
    return YuwellGlucoseBleDevice(
      name: json['name'],
      id: json['id'],
      status: json['status'],
      type: json['type'],
      autoStart: json['autoStart'] ?? false,
    );
  }

  StreamSubscription<Uint8List>? _bleSubscription = null;
  bool found = false;
  @override
  Future<void> onConnect() async {
    print('YuwellGlucoseBleDevice is connected');

    found = false;

    String serviceId = '00001808-0000-1000-8000-00805f9b34fb';
    String notify_uuid = '00002a18-0000-1000-8000-00805f9b34fb';

    // Subscribe to a characteristic
    UniversalBle.setNotifiable(
      this.id,
      serviceId,
      notify_uuid,
      BleInputProperty.notification,
    );

    // Get characteristic updates using stream
    _bleSubscription =
        UniversalBle.characteristicValueStream(this.id, notify_uuid).listen((
          Uint8List value,
        ) {
          print(
            'YuwellGlucoseBleDevice OnValueChange $this.id, $notify_uuid, ${toHex(value)}',
          );
          String hexValue = toHex(value);
          // parse the value

          if (found == false) {
            int dtx =
                (int.parse(hexValue.substring(10 * 2, 22), radix: 16) * 1.8)
                    .toInt();
            print('Dtx: $dtx');
            found = true;
            onValueChanged?.call({
              'deviceId': this.id,
              'name': this.name,
              'type': 'dtx',
              'dtx': dtx,
            });
            // cancelSubscription();
            // UniversalBle.disconnect(this.id);
          }
        });
    print('YuwellGlucoseBleDevice Subscribed');
  }

  Future<void> cancelSubscription() async {
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      _bleSubscription = null;
      print('YuwellGlucoseBleDevice cancel subscription');
    }
  }

  @override
  Future<void> onDisconnect() async {
    print('YuwellGlucoseBleDevice is disconnected');
    if (_bleSubscription != null) {
      _bleSubscription!.cancel();
      _bleSubscription = null;
      print('YuwellGlucoseBleDevice cancel subscription');
    }
  }

  @override
  Future<void> onTick() async {
    String serviceId = '00001808-0000-1000-8000-00805f9b34fb';

    List<BleService> services = await UniversalBle.discoverServices(this.id);

    BleService service = services.firstWhere(
      (service) => service.uuid == serviceId,
    );

    BleCharacteristic characteristic = service.characteristics.firstWhere(
      (characteristic) =>
          characteristic.uuid == "00002a52-0000-1000-8000-00805f9b34fb",
    );

    print(characteristic.uuid);

    await UniversalBle.writeValue(
      this.id,
      serviceId,
      "00002a52-0000-1000-8000-00805f9b34fb",
      Uint8List.fromList([0x01, 0x01]),
      BleOutputProperty.withResponse,
    );
    print('AccuchekBleDevice is ticking');

    // BleCharacteristic characteristic = await service.getCharacteristic('2a56');
    // print('AccuchekBleDevice is ticking');

    // characteristic.write(
    //   Uint8List.fromList([0x01, 0x01]),
    //   BleOutputProperty.withResponse,
    // );
    // UniversalBle.writeValue(
    //   this.id,
    //   serviceId,
    //   "00002a52-0000-1000-8000-00805f9b34fb",
    //   Uint8List.fromList([0x01, 0x01]),
    //   BleOutputProperty.withResponse,
    // );
  }
}
