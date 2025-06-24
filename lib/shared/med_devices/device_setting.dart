import 'package:flutter/material.dart';
import 'package:universal_ble/universal_ble.dart';
import 'package:smarttelemed/shared/med_devices/device_manager.dart';
import 'package:smarttelemed/shared/med_devices/device.dart';
import 'package:smarttelemed/shared/med_devices/device_factory.dart';

class DeviceSetting extends StatefulWidget {
  const DeviceSetting({super.key});

  @override
  State<DeviceSetting> createState() => _DeviceSettingState();
}

class _DeviceSettingState extends State<DeviceSetting> {
  late List<Device> _devices; // Saved devices
  final List<BleDevice> _scannedDevices = []; // Temporary scanned devices
  final DeviceManager _deviceManager = DeviceManager();
  late StateSetter setDeviceSetting;

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

    print("startScanAndShowDialog");

    late StateSetter setStateDialog;

    UniversalBle.onScanResult = (bleDevice) {
      print("onScanResult: ${bleDevice.name}  ${bleDevice.deviceId}");
      if (bleDevice.name != null &&
          !_scannedDevices.any((d) => d.deviceId == bleDevice.deviceId)) {
        setStateDialog(() => _scannedDevices.add(bleDevice));
      }
    };
    await UniversalBle.startScan();
    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setState) {
          setStateDialog = setState;
          return AlertDialog(
            title: const Text('Select a device'),
            content: SizedBox(
              width: double.maxFinite,
              // height: 1000,
              child: ListView.builder(
                itemCount: _scannedDevices.length,
                itemBuilder: (context, index) {
                  final device = _scannedDevices[index];
                  return ListTile(
                    title: Text(device.name ?? 'Unknown'),
                    subtitle: Text(device.deviceId),
                    onTap: () {
                      setDeviceSetting(
                        () => _devices.add(
                          DeviceFactory.createBleDevice(device) as Device,
                        ),
                      );
                      Navigator.of(ctx).pop();
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
                  Navigator.of(ctx).pop();
                },
                child: const Text('Cancel'),
              ),
            ],
          );
        },
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
      debugShowCheckedModeBanner: false,
      home: StatefulBuilder(
        builder: (context, setState) {
          setDeviceSetting = setState;
          return Scaffold(
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
                IconButton(
                  icon: const Icon(Icons.bluetooth),
                  onPressed: () => _deviceManager.start(),
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
                          title: Text(
                            device.name + " " + device.type ?? 'Unknown',
                          ),
                          subtitle: Text(device.id ?? 'Unknown'),
                        ),
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}
