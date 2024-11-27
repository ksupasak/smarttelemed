import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/splash_screen/splashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocaleProvider extends ChangeNotifier {
  // Locale _locale =  Locale('en'); // ค่าเริ่มต้นเป็นภาษาอังกฤษ

  Locale locales = Locale("th");

  void setLocale(Locale locale) {
    locales = locale;
    notifyListeners(); // แจ้งให้ UI อัปเดต
  }

  void clearLocale() {
    locales = const Locale('en'); // คืนค่าเป็นค่าเริ่มต้น
    notifyListeners();
  }
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => DataProvider())),
      ],
      child: const MaterialApp(
        localizationsDelegates: const [
          S.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('en'),
          Locale('th'),
        ],
        locale: Locale('en'), // LocaleProvider().locales,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: SplashScreen()),
      ),
    );
  }
}
