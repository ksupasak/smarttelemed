import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart'; 
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart'; 
import 'package:smarttelemed/station/local/local.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;

class Initsetting extends StatefulWidget {
  const Initsetting({super.key});

  @override
  State<Initsetting> createState() => _InitsettingState();
}

class _InitsettingState extends State<Initsetting> {
  TextEditingController platfromURL = TextEditingController();
  TextEditingController name_hospital = TextEditingController();

  TextEditingController care_unit_id = TextEditingController();
  TextEditingController care_unit = TextEditingController();
  TextEditingController passwordsetting = TextEditingController();

  TextEditingController id_hospital = TextEditingController();
  late List<RecordSnapshot<int, Map<String, Object?>>> dataHospital;
  var resTojson;
  var resTojson2;
  void test() {
    //  name_hospital.text = 'Name Hospital';
    //  care_unit.text = 'care unit 01';
    platfromURL.text =
        'https://emr-life.com/clinic_master/clinic/Api/list_care_unit';

    //  care_unit_id.text = '63d7a282790f9bc85700000e'; //63d79d61790f9bc857000006
    //  passwordsetting.text = '';
  }

  void sync() async {
    try {
      var url = Uri.parse(
          'https://emr-life.com/clinic_master/clinic/Api/list_care_unit'); //${context.read<stringitem>().uri}
      var res = await http.post(url, body: {'code': id_hospital.text});
      resTojson2 = json.decode(res.body);
      print(resTojson2);
      setState(() {
        print('addข้อมูลใหม่');

        if (resTojson2['message'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'Add Id Hospital success',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )))));
          setState(() {
            name_hospital.text = 'NAME HOSPITAL';
          });
        } else if (resTojson2['message'] == 'not found customer') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Container(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    'ไม่พบ ID Hospital',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )))));
        } else {}
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'platfromURL ผิด1',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void safe() async {
    context.read<DataProvider>().name_hospital = name_hospital.text;
    context.read<DataProvider>().platfromURL = platfromURL.text;
    context.read<DataProvider>().care_unit_id = care_unit_id.text;
    context.read<DataProvider>().passwordsetting = passwordsetting.text;
    context.read<DataProvider>().care_unit = care_unit.text;
    setState(() {
      addDataInfoToDatabase(context.read<DataProvider>());
      Navigator.pop(context);
    });
  }

  Future<void> printDatabase() async {
    var knownDevice;

    dataHospital = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in dataHospital) {
      name_hospital.text = record['name_hospital'].toString();
      platfromURL.text = record['platfromURL'].toString();
      care_unit_id.text = record['care_unit_id'].toString();
      care_unit.text = record['care_unit'].toString();
      passwordsetting.text = record['passwordsetting'].toString();
      knownDevice = record['device'];
      print(name_hospital.text);
      print(platfromURL.text);
      print(care_unit_id.text);
      print(passwordsetting.text);
      // for (var knownDevices in knownDevice) {
      //   print(knownDevices);
      // }
    }
    print('เช็คapi');
    check_api();
  }

  void check_api() async {
    var url = Uri.parse('${platfromURL.text}/check_connect');
    var res = await http.post(url, body: {
      'care_unit_id': care_unit_id.text,
    });
    resTojson = json.decode(res.body);
    print(resTojson);
    if (resTojson['message'] == 'success') {
      print('เชื่อมต่อapiได้');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เชื่อมต่อURLสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    } else {
      print('เชื่อมต่อURLไม่สำเร็จ');
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เชื่อมต่อ care_unit_id ของโรงพยาบาลไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  @override
  void initState() {
    printDatabase();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: (() {
          FocusScope.of(context).requestFocus(FocusNode());
        }),
        child: Scaffold(
            body: Stack(children: [
          backgrund(),
          Positioned(
              child: ListView(children: [
            Container(
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                  BoxTextFieldSetting(
                      keyvavlue: platfromURL, texthead: 'PlatfromURL'),
                  BoxTextFieldSetting(
                      keyvavlue: id_hospital, texthead: 'Id_Hospital'),
                  Container(
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                sync();
                              },
                              child: BoxWidetdew(
                                  text: 'Sync',
                                  height: 0.04,
                                  width: 0.2,
                                  radius: 2.0,
                                  textcolor: Colors.white,
                                  fontSize: 0.04,
                                  color: Colors.blue)))),
                  Container(
                    height: resTojson2 != null
                        ? resTojson2['data'].length != 0
                            ? _height * 0.3
                            : 0
                        : 0,
                    child: resTojson2 != null
                        ? resTojson2['data'].length != 0
                            ? ListView.builder(
                                itemCount: resTojson2['data'].length,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        care_unit.text =
                                            resTojson2['data'][index]['name'];
                                        care_unit_id.text =
                                            resTojson2['data'][index]['id'];
                                        name_hospital.text =
                                            resTojson2['customer_name'];
                                      });
                                    },
                                    child: Container(
                                        width: _width * 0.08,
                                        height: _height * 0.05,
                                        child: Center(
                                            child: Text(
                                                resTojson2['data'][index]
                                                    ['name'],
                                                style: TextStyle(
                                                    color: Colors.green)))),
                                  );
                                })
                            : Container(
                                color: Colors.black,
                              )
                        : Container(
                            color: Colors.red,
                          ),
                  ),
                  BoxTextFieldSetting(
                      keyvavlue: name_hospital, texthead: 'Name_Hospital'),
                  BoxTextFieldSetting(
                      keyvavlue: care_unit, texthead: 'Care_Unit'),
                  BoxTextFieldSetting(
                      keyvavlue: care_unit_id, texthead: 'Care_Unit_id'),
                  BoxTextFieldSetting(
                      lengthlimitingtextinputformatter: 4,
                      keyvavlue: passwordsetting,
                      texthead: 'Passwordsetting',
                      textinputtype: TextInputType.number),
                  SizedBox(
                    height: _height * 0.05,
                  ),
                  Container(
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                safe();
                              },
                              child: BoxWidetdew(
                                  text: 'บันทึก',
                                  height: 0.07,
                                  width: 0.6,
                                  radius: 2.0,
                                  textcolor: Colors.white,
                                  fontSize: 0.05,
                                  color: Color.fromARGB(255, 54, 200, 244))))),
                  Container(
                      child: Center(
                          child: GestureDetector(
                              onTap: () {
                                test();
                                //    sync();
                              },
                              child: BoxWidetdew(
                                  text: 'test',
                                  height: 0.07,
                                  width: 0.6,
                                  radius: 2.0,
                                  textcolor: Colors.black,
                                  fontSize: 0.05,
                                  color: Color.fromARGB(255, 255, 255, 255))))),
                ]))
          ]))
        ])));
  }
}
