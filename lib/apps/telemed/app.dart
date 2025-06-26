import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/local.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/splash_screen/splash_screen.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';
import 'package:smarttelemed/apps/telemed/views/station/home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_register.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_home.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_record.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_health_entry.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_appointment.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_waiting.dart';
import 'package:smarttelemed/apps/telemed/views/station/session_summary.dart';
import 'package:smarttelemed/apps/telemed/views/setting/setting.dart';
import 'package:smarttelemed/shared/med_devices/device_manager.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';
import 'package:window_manager/window_manager.dart';
import 'dart:io';

class TelemedStationApp extends StatefulWidget {
  const TelemedStationApp({super.key});

  @override
  State<TelemedStationApp> createState() => _TelemedStationAppState();
}

class _TelemedStationAppState extends State<TelemedStationApp> {
  String s = "th";

  DeviceManager _deviceManager = DeviceManager.instance;
  //  static const int SPLASH_SCREEN = 0;
  //   static const int HOME_SCREEN = 1; // read id card home page
  //   static const int PATIENT_REGISTER_SCREEN = 2; // patient register page
  //   static const int PATIENT_HOME_SCREEN = 3; // patient home page
  //   static const int PATIENT_HEALTH_RECORD_SCREEN =
  //       4; // patient health record page
  //   static const int PATIENT_HEALTH_ENTRY_SCREEN = 5; // patient health entry page
  //   static const int PATIENT_APPOINTMENT_SCREEN = 6;
  //   static const int SESSION_WAITING_SCREEN = 7;
  //   static const int SESSION_SUMMARY_SCREEN = 9;

  // final List<Widget> _pages = [
  //   const SplashScreen(),
  //   const HomeTelemed(),
  //   const PatientRegister(),
  //   const PatientHome(),
  //   const PatientHealthRecord(),
  //   const PatientHealthEntry(),
  //   const PatientAppointment(),
  //   const SessionWaiting(),
  //   const SessionSummary(),
  //   const Setting(),
  // ];

  void getS() async {
    List<RecordSnapshot<int, Map<String, Object?>>>? language =
        await getLanguageApp();
    if (language.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> data in language) {
        s = data["s"].toString();
        setState(() {});
      }
    }
  }

  void fullscreen() async {
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      await windowManager.setFullScreen(true);
    }
  }

  @override
  void initState() {
    getS();
    super.initState();
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   fullscreen();
    // });
    _deviceManager.load().then((_) {
      // _deviceManager.setOnValueChanged(onValueChanged);
      _deviceManager.start();
    });
  }

  @override
  Widget build(BuildContext context) {
    // final currentPage = context.watch<DataProvider>().currentPage;

    context.read<DataProvider>().setContext(context);
    // if (currentPage != 0) {
    //   Widget page = getPage(currentPage);
    //   Navigator.pushReplacement(
    //     context,
    //     MaterialPageRoute(builder: (context) => page),
    //   );
    // }

    return MaterialApp(
      theme: ThemeData(fontFamily: 'Prompt'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: const [Locale('en'), Locale('th')],
      locale: Locale(s), // LocaleProvider().locales,
      color: Colors.white,
      debugShowCheckedModeBanner: false,
      home: Stage().getPage(context.read<DataProvider>().currentPage),
    );
  }
}
