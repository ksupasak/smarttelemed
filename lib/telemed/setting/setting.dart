import 'package:flutter/material.dart';

import 'package:smarttelemed/myapp/action/playsound.dart';

import 'package:smarttelemed/myapp/widgetdew.dart';
import 'package:smarttelemed/telemed/setting/init_setting.dart';
import 'package:smarttelemed/telemed/setting/min_max.dart';
import 'package:smarttelemed/telemed/setting/settingListPrinter.dart';
import 'package:smarttelemed/telemed/setting/talamed_setting.dart';
import 'package:smarttelemed/telemed/splash_screen/splashScreen.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    //  double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: GestureDetector(
          onTap: (() {
            FocusScope.of(context).requestFocus(FocusNode());
          }),
          child: Stack(
            children: [
              const backgrund(),
              Positioned(
                child: SizedBox(
                  width: width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Initsetting()));
                          },
                          child: BoxSetting(text: 'Init Setting')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TalamedSetting()));
                          },
                          child: BoxSetting(text: 'Telemed  Setting')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingMinMax()));
                          },
                          child: BoxSetting(text: 'Min Max')),
                      GestureDetector(
                          onTap: () {
                            keypad_sound();

                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingListPrinter()));
                          },
                          child: BoxSetting(text: 'ListPrinter')),
                      GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SplashScreen()));
                          },
                          child: BoxSetting(text: 'Exit')),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}