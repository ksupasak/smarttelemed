// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, camel_case_types, use_build_context_synchronously

import 'dart:async';
import 'dart:io';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/station/local/local.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/test/esm_idcard.dart';
import 'package:smarttelemed/station/views/pages/home.dart';
import 'package:smarttelemed/station/views/pages/numpad.dart';
import 'package:window_manager/window_manager.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({super.key});

  @override
  State<Splash_Screen> createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  var name_hospital;
  var care_unit;
  var care_unit_id;
  var platfromURL;
  var passwordsetting;
  var myapp;
  late List<RecordSnapshot<int, Map<String, Object?>>> init;
  bool status = false;
  final idcard = Numpad();
  ESMIDCard? reader;
  Stream<String>? entry;
  Timer? readingtime;
  Timer? reading;

  Future<void> printDatabase() async {
    init = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in init) {
      name_hospital = record['name_hospital'].toString();
      platfromURL = record['platfromURL'].toString();
      care_unit_id = record['care_unit_id'].toString();
      passwordsetting = record['passwordsetting'].toString();
      myapp = record['myapp'].toString();
      care_unit = record['care_unit'].toString();
      debugPrint(name_hospital);
      debugPrint(platfromURL);
      debugPrint(care_unit_id);
      debugPrint(care_unit);
      debugPrint(passwordsetting);
      safe();
    }
  }

  void safe() {
    context.read<DataProvider>().name_hospital = name_hospital;
    context.read<DataProvider>().platfromURL = platfromURL;
    context.read<DataProvider>().care_unit_id = care_unit_id;
    context.read<DataProvider>().passwordsetting = passwordsetting;
    context.read<DataProvider>().care_unit = care_unit;
    context.read<DataProvider>().myapp = myapp;
    setState(() {
      addDataInfoToDatabase(context.read<DataProvider>());
    });
  }

  void fullscreen() async {
    if (Platform.isWindows) {
      await windowManager.ensureInitialized();
      windowManager.setFullScreen(
          context.read<DataProvider>().windowManagersetFullScreen);
    }
  }
 void _getprinter() async{
  
 List<RecordSnapshot<int, Map<String, Object?>>> datas = await getPrinter();
 if (datas.length != 0) {
for(RecordSnapshot<int, Map<String, Object?>>  data in datas){
   debugPrint("namePrinters  :${data["namePrinters"]}");
   context.read<DataProvider>().printername = data["namePrinters"].toString();
}

 }

 
   
  }
  @override
  void initState() {
  // fullscreen();
    _getprinter();
    printDatabase();
    Future.delayed(const Duration(seconds: 1), () {
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const Homeapp()));
    });

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        Positioned(
          child: Center(
            child: SizedBox(
              width: width,
              height: height,
              child: SizedBox(
                height: height * 0.2,
                width: width,
                child: SvgPicture.asset(
                  'assets/splash.svg',
                  fit: BoxFit.fill,
                ),
              ),
            ),
          ),
        ),
        Positioned(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                      height: width * 0.1,
                      width: width * 0.1,
                      child: const CircularProgressIndicator(
                        color: Color.fromARGB(255, 139, 0, 0),
                      )),
                ],
              ),
              SizedBox(height: width * 0.1, width: width * 0.1),
            ],
          ),
        )
      ],
    ));
  }
}
