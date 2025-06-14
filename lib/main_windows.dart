import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _ble = UniversalBle();
  List<BleDevice> _devices = [];

  @override
  void initState() {
    super.initState();
    initBle();
  }

  Future<void> initBle() async {
    // Or set a handler
    UniversalBle.onScanResult = (bleDevice) {
      setState(() {
        _devices.add(bleDevice);
      });
    };

    // Perform a scan
    UniversalBle.startScan();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('BLE Scanner')),
        body: ListView.builder(
          itemCount: _devices.length,
          itemBuilder: (context, index) {
            final device = _devices[index];
            return ListTile(
              title: Text(device.name ?? 'Unknown'),
              subtitle: Text(device.deviceId),
            );
          },
        ),
      ),
    );
  }
}
