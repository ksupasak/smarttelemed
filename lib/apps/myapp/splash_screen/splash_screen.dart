// ignore_for_file: use_build_context_synchronously, unnecessary_string_interpolations, camel_case_types

import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

import 'package:smarttelemed/apps/myapp/provider/provider.dart';
import 'package:smarttelemed/apps/myapp/setting/local.dart';
import 'package:smarttelemed/apps/myapp/setting/setting.dart';
import 'package:smarttelemed/apps/myapp/splash_screen/function_splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smarttelemed/apps/station/main_app/app.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  late List<RecordSnapshot<int, Map<String, Object?>>> initUser;

  Future<void> getDeviceInformation() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();

    if (Platform.isAndroid) {
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      debugPrint('Device Model: ${androidInfo.model}');
      debugPrint('Device ID: ${androidInfo.id}');
      setState(() {
        context.read<DataProvider>().appId = androidInfo.id.toString();
      });
      // และข้อมูลอื่น ๆ ตามที่คุณต้องการ
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
      debugPrint('Device Model: ${iosInfo.model}');
      debugPrint('Device ID: ${iosInfo.identifierForVendor}');
      setState(() {
        context.read<DataProvider>().appId = iosInfo.identifierForVendor
            .toString();
      });

      // และข้อมูลอื่น ๆ ตามที่คุณต้องการ
    } else if (Platform.isWindows) {
      WindowsDeviceInfo windowsInfo = await deviceInfo.windowsInfo;
      debugPrint('Device Model: ${windowsInfo.computerName}');
      debugPrint('Device ID: ${windowsInfo.numberOfCores}');
    }
  }

  void setdata() async {
    Future<bool> data = showDataBaseDatauserApp();

    if (!await data) {
      debugPrint('ไม่มีข้อมูล');
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Setting()),
          );
        });
      });
    } else {
      debugPrint('มีข้อมูล');
      redDatabase();
    }
  }

  Future<void> redDatabase() async {
    debugPrint('กำลังโหลดข้อมูล');
    init = await getAllData();
    initUser = await getAllDataUser();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().app = record['myapp'].toString();
      context.read<DataProvider>().name_hospital = record['name_hospital']
          .toString();
      context.read<DataProvider>().platfromURL = record['platfromURL']
          .toString();
      context.read<DataProvider>().care_unit = record['care_unit'].toString();
      context.read<DataProvider>().care_unit_id = record['care_unit_id']
          .toString();
      context.read<DataProvider>().password = record['passwordsetting']
          .toString();
      context.read<DataProvider>().care_unit = record['care_unit'].toString();
    }
    for (RecordSnapshot<int, Map<String, Object?>> record in initUser) {
      context.read<DataProvider>().user_id = record['id'].toString();
      context.read<DataProvider>().user_name = record['name'].toString();
      context.read<DataProvider>().user_code = record['code'].toString();
    }
    debugPrint('App');
    debugPrint('${context.read<DataProvider>().app}');
    debugPrint('${context.read<DataProvider>().name_hospital}');

    debugPrint('${context.read<DataProvider>().platfromURL}');

    debugPrint('${context.read<DataProvider>().care_unit}');
    debugPrint('${context.read<DataProvider>().care_unit_id}');
    debugPrint('${context.read<DataProvider>().password}');
    debugPrint('user');
    debugPrint('${context.read<DataProvider>().user_id}');
    debugPrint('${context.read<DataProvider>().user_name}');
    debugPrint('${context.read<DataProvider>().user_code}');
    debugPrint('โหลดเสร็จเเล้ว');
    Future.delayed(const Duration(seconds: 1), () {
      setState(() {
        redipDatabase();
      });
    });
  }

  Future<void> redipDatabase() async {
    debugPrint('กำลังโหลดDevice');
    init = await getdevice();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      context.read<DataProvider>().mapdevices = record['mapdevices'].toString();
    }

    debugPrint('ip-device =${context.read<DataProvider>().mapdevices}');
    debugPrint('โหลดเสร็จเเล้ว');
    myapp();
  }

  void myapp() {
    if (context.read<DataProvider>().app == 'care_giver') {
      debugPrint('เข้าสู่->CareGiver');
      // Navigator.pushReplacement(context,
      //     MaterialPageRoute(builder: (context) => const Center_Caregiver()));
    } else if (context.read<DataProvider>().app == 'station') {
      debugPrint('เข้าสู่->Station');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const App()),
      );
    } else {
      debugPrint('เข้าสู่->Setting');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const Setting()),
      );
    }
  }

  void getconfig() async {
    List<RecordSnapshot<int, Map<String, Object?>>>? dataconfig;
    dataconfig = await getInOutHospital();
    debugPrint("dataconfig INHospital $dataconfig");
    if (dataconfig?.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> record in dataconfig!) {
        if (record["in_hospital"] != "true") {
          context.read<DataProvider>().in_hospital = false;
          setState(() {});
        }
        if (record['requirel_id_card'] != "true") {
          context.read<DataProvider>().requirel_id_card = false;
          setState(() {});
        }
        if (record['require_VN'] != "true") {
          context.read<DataProvider>().require_VN = false;
          setState(() {});
        }
        context.read<DataProvider>().text_no_idcard = record["text_no_idcard"]
            .toString();
        context.read<DataProvider>().text_no_hn = record["text_no_hn"]
            .toString();
        context.read<DataProvider>().text_no_vn = record["text_no_vn"]
            .toString();
      }
    }
  }

  @override
  void initState() {
    getconfig();
    getDeviceInformation();
    debugPrint('เข้าหน้าsplash');
    setdata();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return style_height();
  }

  // ignore: non_constant_identifier_names
  Widget style_height() {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              child: SizedBox(
                width: width,
                height: height,
                child: SvgPicture.asset(
                  'assets/splash/backlogo.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
            Positioned(
              child: SizedBox(
                width: width,
                height: width,
                child: Center(
                  child: SizedBox(
                    width: width * 0.8,
                    height: width * 0.8,
                    child: SvgPicture.asset('assets/splash/logo.svg'),
                  ),
                ),
              ),
            ),
            const Positioned(
              right: 0,
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 139, 130),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
