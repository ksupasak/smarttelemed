import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/telemed/local/local.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/setting/setting.dart';
import 'package:smarttelemed/telemed/views/home.dart';
import 'package:window_manager/window_manager.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  @override
  void initState() {
    setdata();

    fullscreen();
    super.initState();
  }

  void fullscreen() async {
    // if (Platform.isWindows) {
    //   await windowManager.ensureInitialized();
    //   windowManager.setFullScreen(
    //       context.read<DataProvider>().windowManagersetFullScreen);
    // }
  }

  void setdata() async {
    Future<bool> data = showDataBaseDatauserApp();

    if (!await data) {
      debugPrint('ไม่มีข้อมูล');
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Setting()));
        });
      });
    } else {
      debugPrint('มีข้อมูล');
      debugPrint('กำลังโหลดข้อมูล');
      init = await getAllData();
      DataProvider provider = context.read<DataProvider>();
      for (RecordSnapshot<int, Map<String, Object?>> record in init) {
        provider.app = record['myapp'].toString();
        provider.name_hospital = record['name_hospital'].toString();
        provider.platfromURL = record['platfromURL'].toString();
        provider.platfromURLGateway = record['platfromURLGateway'].toString();
        provider.care_unit = record['care_unit'].toString();
        provider.care_unit_id = record['care_unit_id'].toString();
        provider.password = record['passwordsetting'].toString();
        provider.care_unit = record['care_unit'].toString();
      }
      provider.debugPrintV("App :${provider.app}");
      provider.debugPrintV("Name Hospital :${provider.name_hospital}");
      provider.debugPrintV("PlatfromURL :${provider.platfromURL}");
      provider
          .debugPrintV("platfromURLGateway :${provider.platfromURLGateway}");
      provider.debugPrintV("Care Unit :${provider.care_unit}");
      provider.debugPrintV("Care Unit Id :${provider.care_unit_id}");
      provider.debugPrintV("Password Setting :${provider.password}");
      debugPrint('โหลดInfoเสร็จเเล้ว');
      getconfig();
    }
  }

  void getconfig() async {
    List<RecordSnapshot<int, Map<String, Object?>>>? dataconfig;
    dataconfig = await getInOutHospital();
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("RecordSnapshot : $dataconfig");
    if (dataconfig.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> record in dataconfig) {
        if (record["in_hospital"] != "true") {
          provider.in_hospital = false;
          setState(() {});
        }
        if (record['requirel_id_card'] != "true") {
          provider.requirel_id_card = false;
          setState(() {});
        }
        if (record['require_VN'] != "true") {
          provider.require_VN = false;
          setState(() {});
        }
        provider.text_no_idcard = record["text_no_idcard"].toString();
        provider.text_no_hn = record["text_no_hn"].toString();
        provider.text_no_vn = record["text_no_vn"].toString();
      }
    }
    provider.debugPrintV("INHospital :${provider.in_hospital}");
    provider.debugPrintV("requirel_id_card :${provider.requirel_id_card}");
    provider.debugPrintV("require_VN :${provider.require_VN}");
    provider.debugPrintV("text_no_idcard :${provider.text_no_idcard}");
    provider.debugPrintV("text_no_hn :${provider.text_no_hn}");
    provider.debugPrintV("text_no_vn :${provider.text_no_vn}");
    getprinterList();
  }

  void getprinterList() async {
    DataProvider provider = context.read<DataProvider>();
    List<RecordSnapshot<int, Map<String, Object?>>> datas = await getPrinter();
    provider.debugPrintV("ListPrinters  :$datas");

    if (datas.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> data in datas) {
        provider.printername = data["namePrinters"].toString();
        provider.debugPrintV("namePrinters  :${datas[0]["namePrinters"]}");
      }
    } else {
      provider.debugPrintV("data");
    }

    getmin_max();
  }

  void getmin_max() async {
    List<RecordSnapshot<int, Map<String, Object?>>> data = await getMinMax();
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV(data.toString());
    if (data != []) {
      for (RecordSnapshot<int, Map<String, Object?>> record in data) {
        provider.datamin_max['minsys'] = record["minsys"].toString();
        provider.datamin_max['maxsys'] = record["maxsys"].toString();
        provider.datamin_max['minspo2'] = record["minspo2"].toString();
        provider.datamin_max['maxspo2'] = record["maxspo2"].toString();
        provider.datamin_max['mindia'] = record["mindia"].toString();
        provider.datamin_max['maxdia'] = record["maxdia"].toString();
        provider.datamin_max['mintemp'] = record["mintemp"].toString();
        provider.datamin_max['maxtemp'] = record["maxtemp"].toString();
        provider.datamin_max['minbmi'] = record["minbmi"].toString();
        provider.datamin_max['maxbmi'] = record["maxbmi"].toString();
      }
    }
    setState(() {
      Future.delayed(const Duration(seconds: 1), () {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeTelemed()));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
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
                  ))),
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
          )),
          const Positioned(
            right: 0,
            child: Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                color: Color.fromARGB(255, 0, 139, 130),
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
