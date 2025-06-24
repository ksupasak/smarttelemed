import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:universal_ble/universal_ble.dart';
import 'dart:async';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'BLE Test',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const BleScanner(),
    );
  }
}

class BleScanner extends StatefulWidget {
  const BleScanner({super.key});

  @override
  State<BleScanner> createState() => _BleScannerState();
}

class _BleScannerState extends State<BleScanner> {
  final List<BleDevice> _devices = [];
  BleDevice? _connectedDevice;
  String _log = '';
  final String targetService =
      '00001808-0000-1000-8000-00805f9b34fb'; // Replace
  final String writeChar = '00002a52-0000-1000-8000-00805f9b34fb'; // Replace
  final String notifyChar = '00002a18-0000-1000-8000-00805f9b34fb'; // Replace

  @override
  void initState() {
    super.initState();
    _startScan();
  }

  void _startScan() {
    _devices.clear();
    UniversalBle.onScanResult = (device) {
      if (!_devices.any((d) => d.deviceId == device.deviceId)) {
        setState(() => _devices.add(device));
      }
    };
    UniversalBle.startScan();
  }

  String toHex(Uint8List bytes) {
    return bytes.map((b) => b.toRadixString(16).padLeft(2, '0')).join();
  }

  Future<void> _connectAndWrite(BleDevice device) async {
    setState(() {
      _log = "Connecting to ${device.name ?? 'Unknown'}...";
    });

    await UniversalBle.connect(device.deviceId);
    _connectedDevice = device;
    await Future.delayed(
      Duration(seconds: 2),
    ); // Give time to discover services

    setState(() {
      _log += "\nConnected to ${device.deviceId}";
    });

    print("discoverServices: ${device.deviceId}");
    var services = await UniversalBle.discoverServices(device.deviceId);
    print('${services.length} services discovered');
    print(services);

    // Uint8List value = await UniversalBle.readValue(
    //   device.deviceId,
    //   "00001808-0000-1000-8000-00805f9b34fb",
    //   "00002a08-0000-1000-8000-00805f9b34fb",
    // );

    // print('AccuchekBleDevice readValue: ${toHex(value)}');

    // // Write [0x01, 0x01]
    // await UniversalBle.writeValue(
    //   device.deviceId,
    //   targetService,
    //   writeChar,
    //   Uint8List.fromList([0x01, 0x01]),
    //   BleOutputProperty.withResponse,
    // ).timeout(Duration(seconds: 5));
    // print('Write to done');

    // setState(() {
    //   _log += "\nWrite to $writeChar done";
    // });
    await Future.delayed(Duration(seconds: 3)); //

    await UniversalBle.setNotifiable(
      device.deviceId,
      targetService,
      notifyChar,
      BleInputProperty.notification,
    );

    // Subscribe
    StreamSubscription<Uint8List> sub =
        UniversalBle.characteristicValueStream(
          device.deviceId,
          notifyChar,
        ).listen((value) {
          setState(() {
            _log +=
                "\n[Notify] ${value.map((b) => b.toRadixString(16).padLeft(2, '0')).join(' ')}";
          });
        });

    print('sub: $sub');

    await Future.delayed(Duration(seconds: 3));
    // Write [0x01, 0x01]
    for (int i = 0; i < 40; i++) {
      try {
        await UniversalBle.writeValue(
          device.deviceId,
          targetService,
          writeChar,
          Uint8List.fromList([0x01, 0x01]),
          BleOutputProperty.withResponse,
        ).timeout(Duration(seconds: 2));
        print('Write to done');
      } on TimeoutException catch (e, stackTrace) {
        setState(() {
          _log += "\nTimeout: $e";
        });
      } catch (e, stackTrace) {
        setState(() {
          _log += "\nError: $e";
        });
        print('Error caught: $e');
        print('Stack trace:\n$stackTrace');
      }
      await Future.delayed(Duration(seconds: 2));
    }

    setState(() {
      _log += "\nWrite to $writeChar done";
    });

    setState(() {
      _log += "\nSubscribed to $notifyChar";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BLE Scanner')),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _devices.length,
              itemBuilder: (context, index) {
                final device = _devices[index];
                return ListTile(
                  title: Text(device.name ?? 'Unknown'),
                  subtitle: Text(device.deviceId),
                  onTap: () => _connectAndWrite(device),
                );
              },
            ),
          ),
          const Divider(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(8),
              child: Text(_log),
            ),
          ),
        ],
      ),
    );
  }
}
