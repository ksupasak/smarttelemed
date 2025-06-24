import 'package:smarttelemed/shared/med_devices/device.dart';
import 'package:universal_ble/universal_ble.dart';
import 'dart:typed_data';

abstract class TelemedBleDevice extends Device {
  BleDevice? _bleDevice;

  List<BleService> discoveredServices = [];

  TelemedBleDevice({
    required super.name,
    required super.id,
    required super.type,
    required super.status,
    required super.autoStart,
  });

  BleDevice? get bleDevice => _bleDevice;

  void setBleDevice(BleDevice bleDevice) {
    _bleDevice = bleDevice;
  }

  @override
  Future<void> connect() async {
    print("connect: ${this.id}");
    connectWithRetry();
  }

  @override
  void disconnect() {
    print("disconnect: ${this.id}");
    stopTrying();
  }

  Future<List<BleService>> discoverServices() async {
    print("discoverServices: ${this.id}");
    var services = await UniversalBle.discoverServices(this.id);
    print('${services.length} services discovered');
    print(services);

    return services;
  }

  bool isConnected() {
    return _isConnected;
  }

  @override
  Map<String, dynamic> toJson() => {
    'name': name,
    'id': id,
    'status': status,
    'type': type,
    'autoStart': autoStart,
  };

  bool _keepTrying = false;
  bool _isConnected = false;

  Future<void> onConnect() async {
    print('Device is connected');
  }

  Future<void> onTick() async {
    print('Device is ticking');
  }

  Future<void> onDisconnect() async {
    print('Device is disconnected');
  }

  Future<void> connectWithRetry() async {
    _keepTrying = true;

    // Get connection/disconnection updates using stream
    // UniversalBle.connectionStream(this.id).listen((bool isConnected) {
    //   print('OnConnectionChange $this.id, $isConnected');
    //   if (_keepTrying) {
    //     print('Retrying connection in 5 seconds: $isConnected');
    //     await Future.delayed(Duration(seconds: 5));

    // });

    // }

    // Get connection/disconnection updates using stream

    UniversalBle.connectionStream(this.id).listen((bool isConnected) async {
      print('OnConnectionChange $this.id, $isConnected');
      _isConnected = isConnected;
      if (_isConnected) {
        // bool? res = await UniversalBle.isPaired(this.id);
        // print('Pair result: $res');
        // if (res == false) {
        //   await UniversalBle.pair(this.id);
        // }
        // res = await UniversalBle.isPaired(this.id);
        // print('Pair result: $res');

        discoveredServices = await discoverServices();
        print('Services discovered');
        print(discoveredServices);
        await Future.delayed(Duration(seconds: 2));
        await onConnect();
      } else {
        discoveredServices.clear();
        print('Services cleared');
        await onDisconnect();
      }
    });

    while (_keepTrying) {
      try {
        if (_isConnected == false) {
          await UniversalBle.connect(this.id); // Your existing connect method
          // bool? res = await UniversalBle.isPaired(this.id);
          // print('Pair result: $res');
          // if (res == false) {
          //   await UniversalBle.pair(this.id);
          // }
          // res = await UniversalBle.isPaired(this.id);
          // print('Pair result: $res');
        } else {
          print('Device is already connected');
          await Future.delayed(Duration(seconds: 2));
          await onTick();
        }
      } catch (e) {
        print('Retrying connection in 2 seconds: $e');
        await Future.delayed(Duration(seconds: 2));
      }
    }
  }

  void stopTrying() {
    UniversalBle.disconnect(this.id);
    _keepTrying = false;
  }

  String toHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  void Function(Map<String, dynamic>)? onValueChanged;
  void setOnValueChanged(void Function(Map<String, dynamic>)? callback) {
    onValueChanged = callback;
  }
}
