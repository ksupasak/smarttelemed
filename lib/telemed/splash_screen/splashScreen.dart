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
      debugPrint("App ${provider.app}");
      debugPrint("Name Hospital ${provider.name_hospital}");
      debugPrint("PlatfromURL ${provider.platfromURL}");
      debugPrint("Care Unit ${provider.care_unit}");
      debugPrint("Care Unit Id ${provider.care_unit_id}");
      debugPrint("Password Setting ${provider.password}");
      provider.debugPrint("App ${provider.app}");
      provider.debugPrint("Name Hospital ${provider.name_hospital}");
      provider.debugPrint("PlatfromURL ${provider.platfromURL}");
      provider.debugPrint("Care Unit ${provider.care_unit}");
      provider.debugPrint("Care Unit Id ${provider.care_unit_id}");
      provider.debugPrint("Password Setting ${provider.password}");
      debugPrint('โหลดเสร็จเเล้ว');
      setState(() {
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const HomeTelemed()));
      });
    }
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
            child: CircularProgressIndicator(
              color: Color.fromARGB(255, 0, 139, 130),
            ),
          ),
        ],
      ),
    ));
  }
}
