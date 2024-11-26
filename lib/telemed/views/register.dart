// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/views/home.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  bool status = false;
  Uint8List? resTojsonImage;
  TextEditingController prefix_name = TextEditingController();
  TextEditingController first_name = TextEditingController();
  TextEditingController last_name = TextEditingController();
  TextEditingController id = TextEditingController();
  TextEditingController birthdate = TextEditingController();
  TextEditingController hn = TextEditingController();
  TextEditingController phone = TextEditingController();
  @override
  void initState() {
    getdata();
    super.initState();
  }

  void getdata() {
    DataProvider provider = context.read<DataProvider>();
    prefix_name.text = provider.prefixName;
    first_name.text = provider.fname;
    last_name.text = provider.lname;
    id.text = provider.id;
    birthdate.text = provider.birthdate;
  }

  void gitimage() async {
    var url = Uri.parse(
        'http://localhost:8189/api/smartcard/read?readImageFlag=true');
    var res = await http.get(url);
    var resTojson = json.decode(res.body);
    debugPrint(resTojson.toString());
    debugPrint("Imgge: ${resTojson["image"]}");
    id.text = resTojson["pid"];
    first_name.text = resTojson["fname"];
    last_name.text = resTojson["lname"];
    // prefix_name.text = getprefix_name(resTojson["titleName"].toString());
    setState(() {});
  }

  void regter() async {
    setState(() {
      status = true;
    });
    DataProvider provider = context.read<DataProvider>();
    try {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/add_patient');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': id.text,
        'prefix_name': prefix_name.text,
        'first_name': first_name.text,
        'last_name': last_name.text,
        'tle': phone.text,
        'hn': hn.text
      });
      var resTojson = json.decode(res.body);
      if (res.statusCode == 200) {
        provider.debugPrintV("สมัคข้อมูลในESMสำเร็จ");
        provider.debugPrintV("StatusresTojson :${resTojson["message"]}");
      }
      if (resTojson["message"] == "success") {
        setState(() {
          status = false;
        });
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Userinformation()));
        });
      } else {
        provider
            .debugPrintV("สมัคข้อมูลในESMใม่สำเร็จ error:${res.statusCode}");
        setState(() {
          status = false;
        });
      }
    } catch (e) {
      provider.debugPrintV("สมัคข้อมูลในESMใม่สำเร็จ error:$e");
      setState(() {
        status = false;
      });
    }
  }

  Widget BoxData({String? child}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.4,
        height: height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0))),
        child: child != null
            ? Text(child,
                style: const TextStyle(
                  color: Color.fromARGB(255, 0, 28, 155),
                ))
            : const Text('-'));
  }

  Widget Boxheab({required String child}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
        width: width * 0.4,
        height: height * 0.027,
        decoration: BoxDecoration(
            border: Border.all(color: const Color.fromARGB(255, 0, 0, 0))),
        child: Text(child,
            style: const TextStyle(
              color: Color.fromARGB(255, 3, 58, 58),
            )));
  }

  Widget textdatauser({TextEditingController? child}) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    TextStyle style2 =
        TextStyle(fontSize: width * 0.035, color: const Color(0xff003D5C));
    return Row(
      children: [
        SizedBox(width: width * 0.05),
        Container(
          width: width * 0.65,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: TextField(
                onChanged: (value) {
                  if (!value.isNotEmpty) {
                    setState(() {});
                  }
                },
                onTap: () async {
                  try {
                    // ใช้คำสั่ง run แทน start
                    final result =
                        await Process.run('C:\\Windows\\System32\\osk.exe', []);
                    if (result.exitCode != 0) {
                      print('Failed to start keyboard: ${result.stderr}');
                    }
                  } catch (e) {
                    print('Error starting keyboard: $e');
                  }
                },
                onEditingComplete: () {
                  FocusScope.of(context).unfocus();
                },
                controller: child,
                style: style2),
          ),
          decoration: boxDecorate,
        )
      ],
    );
  }

  Decoration boxDecorate = BoxDecoration(boxShadow: const [
    BoxShadow(offset: Offset(0, 2.5), blurRadius: 3, color: Color(0xff31D6AA))
  ], borderRadius: BorderRadius.circular(10), color: Colors.white);

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyle textStyle =
        TextStyle(fontSize: width * 0.06, color: const Color(0xff31D6AA));
    TextStyle style2 =
        TextStyle(fontSize: width * 0.04, color: const Color(0xff003D5C));
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Positioned(
            child: Center(
              child: ListView(
                children: [
                  SizedBox(height: height * 0.1),
                  Center(
                    child: Container(
                      width: width * 0.85,
                      decoration: boxDecorate,
                      child: Column(
                        children: [
                          Text('ลงทะเบียน', style: textStyle),
                          SizedBox(
                            width: width * 0.8,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('คำนำหน้าชื่อ :${prefix_name.text}',
                                      style: style2),
                                  // textdatauser(child: prefix_name),
                                  Text('ชื่อ :${first_name.text}',
                                      style: style2),
                                  //  textdatauser(child: first_name),
                                  Text('นามสกุล :${last_name.text}',
                                      style: style2),
                                  //   textdatauser(child: last_name),
                                  Text(
                                      'วันเกิด(ปี เดือน วัน) :${birthdate.text}',
                                      style: style2),
                                  //   textdatauser(child: birthdate),
                                  Text('เลขประจำตัวประชาชน :${id.text}',
                                      style: style2),
                                  //   textdatauser(child: id),
                                  Text('เบอร์โทร', style: style2),
                                  textdatauser(child: phone),
                                  phone.text == ""
                                      ? const Center(
                                          child: Text(
                                          "กรุณากรอก็เบอร์โทร",
                                          style: TextStyle(color: Colors.red),
                                        ))
                                      : const SizedBox(),
                                  Text('รหัส HN', style: style2),
                                  textdatauser(child: hn),
                                  hn.text == ""
                                      ? const Center(
                                          child: Text(
                                          "กรุณากรอก็HN",
                                          style: TextStyle(color: Colors.red),
                                        ))
                                      : const SizedBox()
                                ]),
                          ),
                          SizedBox(height: height * 0.03),
                          GestureDetector(
                            onTap: regter,
                            child: Container(
                              width: width * 0.35,
                              height: height * 0.06,
                              decoration: BoxDecoration(
                                  color: const Color(0xff31D6AA),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: const [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 2),
                                        blurRadius: 2)
                                  ]),
                              child: Row(
                                children: [
                                  Image.asset('assets/rsjyrsk.png'),
                                  Text('ลงทะเบียน',
                                      style: TextStyle(
                                          fontSize: width * 0.04,
                                          color: Colors.white))
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: height * 0.03),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const HomeTelemed()));
                },
                child: Container(
                  height: height * 0.025,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                          color: const Color.fromARGB(255, 201, 201, 201),
                          width: width * 0.002)),
                  child: Center(
                      child: Text(
                    '< ย้อนกลับ',
                    style: TextStyle(
                        fontSize: width * 0.03,
                        color: const Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
