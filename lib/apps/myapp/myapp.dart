import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';
import 'splash_screen/splash_screen.dart';

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
        color: Colors.grey,
        debugShowCheckedModeBanner: false,
        home: Scaffold(body: Splash_Screen()),
      ),
    );
  }
}
