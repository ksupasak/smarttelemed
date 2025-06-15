import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:smarttelemed/telemed/devices/device_manager.dart';
import 'package:smarttelemed/telemed/devices/device.dart';
import 'package:smarttelemed/telemed/devices/device_factory.dart';

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
  late List<Device> _devices; // Saved devices
  final List<BleDevice> _scannedDevices = []; // Temporary scanned devices
  final DeviceManager _deviceManager = DeviceManager();

  @override
  void initState() {
    super.initState();
    _deviceManager.load().then((_) {
      setState(() {
        _devices = _deviceManager.getDevices();
      });
    });
  }

  Future<void> startScanAndShowDialog(BuildContext context) async {
    _scannedDevices.clear();

    UniversalBle.onScanResult = (bleDevice) {
      if (!_scannedDevices.any((d) => d.deviceId == bleDevice.deviceId)) {
        setState(() => _scannedDevices.add(bleDevice));
      }
    };

    await UniversalBle.startScan();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Select a device'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: _scannedDevices.length,
            itemBuilder: (context, index) {
              final device = _scannedDevices[index];
              return ListTile(
                title: Text(device.name ?? 'Unknown'),
                subtitle: Text(device.deviceId),
                onTap: () {
                  setState(
                    () => _devices.add(
                      DeviceFactory.createBleDevice(device) as Device,
                    ),
                  );
                  Navigator.of(context).pop();
                  UniversalBle.stopScan();
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              UniversalBle.stopScan();
              Navigator.of(context).pop();
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    UniversalBle.stopScan();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: const Text('BLE Devices'),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () => startScanAndShowDialog(context),
              ),
              IconButton(
                icon: const Icon(Icons.save),
                onPressed: () => _deviceManager.saveDevices(_devices),
              ),
            ],
          ),
          body: _devices.isEmpty
              ? const Center(child: Text('No devices added.'))
              : ListView.builder(
                  itemCount: _devices.length,
                  itemBuilder: (context, index) {
                    final device = _devices[index];
                    return Dismissible(
                      key: Key(device.id),
                      onDismissed: (direction) {
                        _deviceManager.removeDevice(device);
                        setState(() {
                          _devices.remove(device);
                        });
                      },
                      child: ListTile(
                        title: Text(device.name ?? 'Unknown'),
                        subtitle: Text(device.id ?? 'Unknown'),
                      ),
                    );
                  },
                ),
        ),
      ),
    );
  }
}
