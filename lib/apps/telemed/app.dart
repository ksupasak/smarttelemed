import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/local.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/splash_screen/splashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';

class TelemedStationApp extends StatefulWidget {
  const TelemedStationApp({super.key});

  @override
  State<TelemedStationApp> createState() => _TelemedStationAppState();
}

class _TelemedStationAppState extends State<TelemedStationApp> {
  String s = "th";

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

  @override
  void initState() {
    getS();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => DataProvider())),
        //  ChangeNotifierProvider(create: ((context) => LocaleProvider())),
      ],
      child: MaterialApp(
        theme: ThemeData(fontFamily: 'Prompt'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: const [Locale('en'), Locale('th')],
        locale: Locale(s), // LocaleProvider().locales,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: SplashScreen()),
      ),
    );
  }
}
