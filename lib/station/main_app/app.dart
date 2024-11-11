import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/provider/provider_function.dart';

import 'package:smarttelemed/station/views/routes/routes_page.dart';

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  void initState() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: ((context) => DataProvider())),
        ChangeNotifierProvider(create: ((context) => Datafunction())),
        ChangeNotifierProvider(create: ((context) => StyleColorsApp()))
      ],
      child: GetMaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: 'splash',
        getPages: Routes.routes,
      ),
    );
  }
}
