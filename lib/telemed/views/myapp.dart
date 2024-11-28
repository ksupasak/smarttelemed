import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/telemed/local/local.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/splash_screen/splashScreen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// class LocaleProvider with ChangeNotifier {
//   // Locale _locale =  Locale('en'); // ค่าเริ่มต้นเป็นภาษาอังกฤษ

//   String S = "th";

//   void setlanguageApp(String s) {
//     S = s;
//     debugPrint("-+++--++---+---");
//     notifyListeners();
//   }
// }

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
        locale: Locale(s), // LocaleProvider().locales,
        color: Colors.white,
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: SplashScreen()),
      ),
    );
  }
}
