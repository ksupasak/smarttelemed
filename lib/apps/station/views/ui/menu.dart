import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/station/background/background.dart';
import 'package:smarttelemed/apps/station/background/color/style_color.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: BackGroundSmart_Health(
              BackGroundColor: [
                StyleColor.backgroundbegin,
                StyleColor.backgroundend,
              ],
            ),
          ),
          Positioned(
            child: Center(
              child: Container(
                height: _height * 0.45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed('healthrecord');
                      }),
                      child: BoxWidetdew(
                        height: 0.1,
                        width: 0.7,
                        text: 'เช็คสุขภาพ',
                        textcolor: Colors.white,
                        color: Color.fromARGB(255, 76, 199, 45),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Get.toNamed('checkqueue');
                      }),
                      child: BoxWidetdew(
                        height: 0.1,
                        width: 0.7,
                        text: 'เช็คคิว',
                        textcolor: Colors.white,
                        color: Color.fromARGB(255, 7, 171, 200),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {}),
                      child: BoxWidetdew(
                        height: 0.1,
                        width: 0.7,
                        text: 'อื่นๆ',
                        textcolor: Colors.white,
                        color: Color.fromARGB(255, 4, 156, 130),
                      ),
                    ),
                    GestureDetector(
                      onTap: (() {
                        Get.offNamed('home');
                      }),
                      child: BoxWidetdew(
                        height: 0.1,
                        width: 0.7,
                        text: 'ออกจากระบบ',
                        textcolor: Colors.white,
                        color: Color.fromARGB(255, 231, 29, 29),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
