import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttelemed/apps/telemed/app.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:provider/provider.dart';
import 'package:media_kit/media_kit.dart';
import 'package:window_manager/window_manager.dart';
//import 'package:smarttelemed/myapp/myapp.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  windowManager.ensureInitialized();
  WindowOptions windowOptions = const WindowOptions(
    fullScreen: true, // Make window full screen
  );
  windowManager.waitUntilReadyToShow(windowOptions, () async {
    await windowManager.show();
    await windowManager.focus();
  });

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((
    _,
  ) {
    runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: ((context) => DataProvider())),
          //  ChangeNotifierProvider(create: ((context) => LocaleProvider())),
        ],
        child: const TelemedStationApp(),
      ),
    );
  });
}
