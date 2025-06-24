// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:smarttelemed/openvidu_flutter/screens/prepare_videocall.dart';
import 'package:smarttelemed/apps/station/views/pages/checkqueue.dart';

import 'package:smarttelemed/apps/station/views/pages/health_record.dart';
import 'package:smarttelemed/apps/station/views/pages/healthrecord/healthRecord2.dart';
import 'package:smarttelemed/apps/station/views/pages/home.dart';
import 'package:smarttelemed/apps/station/views/pages/menu.dart';
import 'package:smarttelemed/apps/station/views/pages/pages_setting/device.dart';
import 'package:smarttelemed/apps/station/views/pages/pages_setting/init_setting.dart';
import 'package:smarttelemed/apps/station/views/pages/regter.dart';
import 'package:smarttelemed/apps/station/views/pages/user_information2.dart';
import 'package:smarttelemed/apps/station/util/device_manager.dart';
import 'package:smarttelemed/apps/station/views/splash/splash_screen.dart';

class Routes {
  static const String splash = '/splash';
  static const String home = '/home';
  static const String menu = '/menu';
  static const String healthrecord = '/healthrecord';
  static const String checkqueue = '/checkqueue';
  static const String device = '/device';
  static const String initsetting = '/initsetting';
  static const String user_information = '/user_information';
  static const String printqueue = '/printqueue';
  static const String regter = '/regter';
  static const String healthRecord2 = '/healthRecord2';
  static const String device_manager = '/device_manager';

  static const String preparevideo = '/preparevideo';

  static const String preparation_videocall = '/preparation_videocall';
  static final routes = [
    GetPage(name: splash, page: (() => const Splash_Screen())),
    GetPage(name: home, page: (() => const Homeapp())),
    GetPage(name: menu, page: (() => const Menu())),
    // GetPage(name: healthrecord, page: (() => const HealthRecord())),
    GetPage(name: checkqueue, page: (() => const CheckQueue())),
    GetPage(name: device, page: (() => const Device())),
    GetPage(name: initsetting, page: (() => const Initsetting())),
    GetPage(name: user_information, page: (() => const UserInformation2())),
    // GetPage(name: printqueue, page: (() => const PrintQueue())),
    GetPage(name: regter, page: (() => const Regter())),
    GetPage(name: healthRecord2, page: (() => const HealthRecord2())),
    GetPage(name: device_manager, page: (() => const DeviceManager())),
    //  GetPage(name: preparevideo, page: (() => const PrePareVideo())),
    GetPage(
      name: preparation_videocall,
      page: (() => const PrepareVideocall()),
    ),
  ];
  // TestRoutes.routes;
}
