import 'package:flutter/material.dart';
import 'package:smarttelemed/shared/med_devices/device_manager.dart';
import 'package:smarttelemed/shared/med_devices/device_setting.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final DeviceManager _deviceManager = DeviceManager.instance;

  @override
  void initState() {
    super.initState();
    _deviceManager.load().then((_) {
      _deviceManager.start();
    });
    // _deviceManager.start();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (context) => DeviceSetting()),
    );
  }
}
