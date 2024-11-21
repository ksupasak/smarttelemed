import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/telemed/local/local.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/setting/setting.dart';
import 'package:smarttelemed/telemed/views/home.dart';

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
    super.initState();
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
        provider.care_unit = record['care_unit'].toString();
        provider.care_unit_id = record['care_unit_id'].toString();
        provider.password = record['passwordsetting'].toString();
        provider.care_unit = record['care_unit'].toString();
      }
      provider.debugPrintV("App :${provider.app}");
      provider.debugPrintV("Name Hospital :${provider.name_hospital}");
      provider.debugPrintV("PlatfromURL :${provider.platfromURL}");
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
    DataProvider Provider = context.read<DataProvider>();
    Provider.debugPrintV("RecordSnapshot : $dataconfig");
    if (dataconfig.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> record in dataconfig) {
        if (record["in_hospital"] != "true") {
          Provider.in_hospital = false;
          setState(() {});
        }
        if (record['requirel_id_card'] != "true") {
          Provider.requirel_id_card = false;
          setState(() {});
        }
        if (record['require_VN'] != "true") {
          Provider.require_VN = false;
          setState(() {});
        }
        Provider.text_no_idcard = record["text_no_idcard"].toString();
        Provider.text_no_hn = record["text_no_hn"].toString();
        Provider.text_no_vn = record["text_no_vn"].toString();
      }
    }
    Provider.debugPrintV("INHospital :${Provider.in_hospital}");
    Provider.debugPrintV("requirel_id_card :${Provider.requirel_id_card}");
    Provider.debugPrintV("require_VN :${Provider.require_VN}");
    Provider.debugPrintV("text_no_idcard :${Provider.text_no_idcard}");
    Provider.debugPrintV("text_no_hn :${Provider.text_no_hn}");
    Provider.debugPrintV("text_no_vn :${Provider.text_no_vn}");
    getprinter();
  }

  void getprinter() async {
    DataProvider Provider = context.read<DataProvider>();
    List<RecordSnapshot<int, Map<String, Object?>>> datas = await getPrinter();
    Provider.debugPrintV("ListPrinters  :$datas");

    if (datas.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> data in datas) {
        context.read<DataProvider>().printername =
            data["namePrinters"].toString();
      }
    }
    Provider.debugPrintV("namePrinters  :${datas[0]["namePrinters"]}");
    setState(() {
      Future.delayed(const Duration(seconds: 2), () {
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
