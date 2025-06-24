import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttelemed/apps/telemed/app.dart';
import 'package:smarttelemed/apps/telemed/views/test/test_serial.dart';
//import 'package:smarttelemed/myapp/myapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(const TelemedStationApp());
  });
}
