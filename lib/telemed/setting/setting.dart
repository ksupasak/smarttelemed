import 'dart:io';

import 'package:flutter/material.dart';

import 'package:smarttelemed/telemed/background.dart/background.dart';

import 'package:smarttelemed/telemed/setting/init_setting.dart';
import 'package:smarttelemed/telemed/setting/language.dart';
import 'package:smarttelemed/telemed/setting/min_max.dart';
import 'package:smarttelemed/telemed/setting/settingListPrinter.dart';
import 'package:smarttelemed/telemed/setting/shutdownWindows.dart';
import 'package:smarttelemed/telemed/setting/talamed_setting.dart';
import 'package:smarttelemed/telemed/setting/ui/boxSetting.dart';
import 'package:smarttelemed/telemed/views/home.dart';

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
              const Background(),
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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const LanguageApp()));
                          },
                          child: BoxSetting(text: 'Language')),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const TalamedSetting()));
                          },
                          child: BoxSetting(text: 'Telemed  Setting')),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingMinMax()));
                          },
                          child: BoxSetting(text: 'Min Max')),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const SettingListPrinter()));
                          },
                          child: BoxSetting(text: 'List Printer')),
                      GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ShutdownWindows()));
                          },
                          child: BoxSetting(text: 'Additional Exit')),
                      GestureDetector(
                          onTap: () {
                            //  Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HomeTelemed()));
                          },
                          child: BoxSetting(text: 'Go to Home')),
                      GestureDetector(
                          onTap: () {
                            //  Navigator.pop(context);
                            // Navigator.pushReplacement(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) =>
                            //             const SplashScreen()));
                            exit(0);
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
