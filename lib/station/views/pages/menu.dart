import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

class Menu extends StatefulWidget {
  const Menu({super.key});

  @override
  State<Menu> createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(children: [
      const backgrund(),
      Positioned(
        child: Center(
            child: SizedBox(
                height: height * 0.45,
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
                              fontSize: 0.05,
                              textcolor: Colors.white,
                              color: const Color.fromARGB(255, 76, 199, 45))),
                      GestureDetector(
                          onTap: (() {
                            Get.toNamed('checkqueue');
                          }),
                          child: BoxWidetdew(
                              height: 0.1,
                              width: 0.7,
                              text: 'เช็คคิว',
                              fontSize: 0.05,
                              textcolor: Colors.white,
                              color: const Color.fromARGB(255, 7, 171, 200))),
                      GestureDetector(
                          onTap: (() {}),
                          child: BoxWidetdew(
                              height: 0.1,
                              width: 0.7,
                              text: 'อื่นๆ',
                              fontSize: 0.05,
                              textcolor: Colors.white,
                              color: const Color.fromARGB(255, 4, 156, 130))),
                      GestureDetector(
                          onTap: (() {
                            Get.offNamed('home');
                          }),
                          child: BoxWidetdew(
                              height: 0.1,
                              width: 0.7,
                              fontSize: 0.05,
                              text: 'ออกจากระบบ',
                              textcolor: Colors.white,
                              color: const Color.fromARGB(255, 231, 29, 29))),
                    ]))),
      )
    ]));
  }
}
