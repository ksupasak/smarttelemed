import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/myapp/action/playsound.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';
import 'package:smarttelemed/apps/myapp/setting/device.dart';
import 'package:smarttelemed/apps/myapp/setting/device/requestLocationPermission.dart';
import 'package:smarttelemed/apps/myapp/setting/init_setting.dart';
import 'package:smarttelemed/apps/myapp/setting/listprinter.dart';
import 'package:smarttelemed/apps/myapp/setting/min_max.dart';
import 'package:smarttelemed/apps/myapp/setting/talamed_setting.dart';
import 'package:smarttelemed/apps/myapp/setting/update_license.dart';
import 'package:smarttelemed/apps/myapp/widgetdew.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  void initState() {
    requestLocationPermission();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
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
                child: Container(
                  width: _width,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          keypad_sound();
                          //    context.read<Datafunction>().playsound();
                          //  Get.toNamed('initsetting');
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Initsetting(),
                            ),
                          );
                        },
                        child: BoxSetting(text: 'Init Setting'),
                      ),
                      GestureDetector(
                        onTap: () {
                          keypad_sound();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TalamedSetting(),
                            ),
                          );
                        },
                        child: BoxSetting(text: 'Telemed  Setting'),
                      ),
                      GestureDetector(
                        onTap: () {
                          keypad_sound();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingMinMax(),
                            ),
                          );
                        },
                        child: BoxSetting(text: 'Min Max'),
                      ),
                      GestureDetector(
                        onTap: () {
                          keypad_sound();

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => SettingListPrinter(),
                            ),
                          );
                        },
                        child: BoxSetting(text: 'ListPrinter'),
                      ),
                      // GestureDetector(
                      //     onTap: () {
                      //       keypad_sound();
                      //       Navigator.push(
                      //           context,
                      //           MaterialPageRoute(
                      //               builder: (context) => Update_License()));
                      //     },
                      //     child: BoxSetting(text: 'Update License')),
                      GestureDetector(
                        onTap: () {
                          keypad_sound();
                          //  context.read<Datafunction>().playsound();
                          //  Get.offNamed('home');
                          if (context.read<DataProvider>().app == "station") {
                            Navigator.pop(context);
                          }
                        },
                        child: BoxSetting(text: 'Exit'),
                      ),
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
