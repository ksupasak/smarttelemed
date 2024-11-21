// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/provider/provider_function.dart';

import 'package:smarttelemed/station/views/pages/numpad.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/popup.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

import 'package:smarttelemed/station/test/esm_idcard.dart';

class Homeapp extends StatefulWidget {
  const Homeapp({super.key});
  @override
  State<Homeapp> createState() => _HomeappState();
}

class _HomeappState extends State<Homeapp> {
  bool status = false;
  final idcard = Numpad();
  ESMIDCard? reader;
  Stream<String>? entry;
  Timer? readingtime;
  Timer? reading;
  bool shownumpad = false;
  Timer? _timer;
  Timer? timerreadIDCard;
  void check2() async {
    setState(() {
      status = true;
    });
    context.read<Datafunction>().playsound();
    if (context.read<DataProvider>().id.length == 13) {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_quick');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      var resTojson = json.decode(res.body);
      debugPrint("resTojson check_quick ${resTojson.toString()}");
      debugPrint(context.read<DataProvider>().dataUserCheckQuick.toString());
      setState(() {
        status = false;
      });
      if (resTojson['message'] == 'not found patient') {
        String isclaimType = context.read<DataProvider>().claimType;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                texthead: 'ไม่พบข้อมูลในระบบ',
                pathicon: 'assets/warning.png',
                buttonbar: [
                  isclaimType != ""
                      ? GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Timer(const Duration(seconds: 2), () {
                              setState(() {
                                Get.toNamed('regter');
                              });
                            });
                          },
                          child: BoxWidetdew(
                              color: Colors.green,
                              height: 0.05,
                              width: 0.2,
                              text: 'สมัคร',
                              radius: 0.0,
                              textcolor: Colors.white))
                      : const SizedBox(),
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: BoxWidetdew(
                          color: Colors.red,
                          height: 0.05,
                          width: 0.2,
                          radius: 0.0,
                          text: 'ออก',
                          textcolor: Colors.white))
                ],
              );
            });
      } else {
        setState(() {
          status = false;
          context.read<DataProvider>().updatedatausercheckquick(resTojson);
          context.read<DataProvider>().dataidcard = resTojson;
        });
        Timer(const Duration(seconds: 1), () {
          Get.toNamed('user_information');
          timerreadIDCard?.cancel();
        });
      }
    } else {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'เลขบัตรประชาชนไม่ครบ',
              textbody: 'กรุณากรองเลขบัตรประชาชนไห้ครบ',
              pathicon: 'assets/warning (1).png',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: BoxWidetdew(
                        color: const Color.fromARGB(255, 106, 143, 173),
                        height: 0.05,
                        width: 0.2,
                        text: 'ตกลง',
                        textcolor: Colors.white))
              ],
            );
          });
      setState(() {
        status = false;
      });
    }
  }

  void getIdCard() async {
    timerreadIDCard = Timer.periodic(const Duration(seconds: 4), (timer) async {
      var url = Uri.parse('http://localhost:8189/api/smartcard/read');
      var res = await http.get(url);
      var resTojson = json.decode(res.body);
      debugPrint("Crde Reader--------------------------------=");
      debugPrint(resTojson.toString());
      if (res.statusCode == 200) {
        context.read<DataProvider>().updateuserinformation(resTojson);
        context.read<DataProvider>().upcorrelationId(resTojson);
        debugPrint(resTojson["claimTypes"][0].toString());
        context
            .read<DataProvider>()
            .updateclaimType(resTojson["claimTypes"][0]);
        agreement();
        timerreadIDCard?.cancel();
      }
    });
  }

  void agreement() {
    if (context.read<DataProvider>().id.length == 13) {
      String texthead =
          'ข้อตกลงในการให้ความยินยอมในการเก็บรวบรวมและใช้ข้อมูลส่วนบุคคล';
      String textbody =
          'ผู้ใช้งานต้องมีสิทธิหลักประกันสุขภาพแห่งชาติ หรือสิทธิอื่น ๆอายุ 15 ปี บริบูรณ์ขึ้นไปลงทะเบียนด้วยตนเองเท่านั้น ยังไม่สามารถลงทะเบียนแทนบุคคลในครอบครัวได้ (ในปัจจุบัน)เพื่อประโยชน์ในการใช้ Line Official Account สปสช. เปลี่ยนหน่วยบริการด้วยตนเองบนมือถือ สำนักงานหลักประกันสุขภาพแห่งชาติ (สปสช.) ขอให้ผู้ใช้งานโปรดแสดงความยินยอมให้ สปสช. เก็บรวบรวม ใช้ หรือเปิดเผยข้อมูลส่วนบุคคลของผู้ใช้งาน รวมถึงข้อมูลส่วนตัว เช่น ชื่อ นามสกุล เลขบัตรประชาชน และข้อมูลอื่นที่เกี่ยวข้องกับสิทธิของผู้ใช้งาน เพื่อการตรวจสอบสิทธิ และให้บริการที่เกี่ยวข้องกับสิทธิหลักประกันสุขภาพแห่งชาติ หรือสิทธิอื่น ๆ ตามกฎหมายในกรณีที่จำเป็น ผู้ใช้งานสามารถขอถอนความยินยอมได้ตลอดเวลา และหากมีข้อสงสัยเกี่ยวกับความยินยอมนี้ ผู้ใช้งานสามารถติดต่อสำนักงานหลักประกันสุขภาพแห่งชาติ ผ่าน Line Official Account สปสช.สอบถามรายละเอียดเพิ่มเติมได้ที่: สายด่วน สปสช. 1330 (เปิดบริการ 24 ชั่วโมง)';
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: texthead,
              textbody: textbody,
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: BoxWidetdew(
                        color: const Color.fromARGB(255, 173, 106, 106),
                        height: 0.05,
                        width: 0.2,
                        text: 'ยกเลิก',
                        textcolor: Colors.white)),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      check2();
                    },
                    child: BoxWidetdew(
                        color: const Color.fromARGB(255, 106, 173, 115),
                        height: 0.05,
                        width: 0.2,
                        text: 'ตกลง',
                        textcolor: Colors.white)),
              ],
            );
          });
    }
  }

  void checkCard() {
    reader?.readAuto();
  }

  @override
  void dispose() {
    readingtime?.cancel();
    reading?.cancel();
    _timer?.cancel();
    timerreadIDCard?.cancel();
    super.dispose();
  }

  void lop() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL == '') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: Center(
                      child: Text(
                    "can't connect URL",
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: MediaQuery.of(context).size.width * 0.03),
                  )))));
        } else {}
      });
    });
  }

  @override
  void initState() {
    setState(() {
      context.read<DataProvider>().id = '';
      context
          .read<DataProvider>()
          .updateuserinformation({"pid": "", "claimTypes": "[]"});
      context.read<DataProvider>().claimType = '';
      context.read<DataProvider>().claimTypeName = '';
      context.read<DataProvider>().claimCode = '';
    });
    getIdCard();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          Positioned(
              child: SafeArea(
            child: ListView(children: [
              BoxTime(),
              //    const BoxRunQueue2(),
              SizedBox(height: height * 0.1),
              SizedBox(
                width: width,
                height: height * 0.7,
                child: Center(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(height: height * 0.02),
                    SizedBox(
                        width: width * 0.6,
                        child:
                            BoxText(text: 'กรุณาเสียบบัตรประชาชนหรือกรอกรหัส')),
                    SizedBox(
                        width: width * 0.6,
                        child:
                            BoxText(text: 'บัตรประชาชน เพื่อทำการเข้าสู่ระบบ')),
                    SizedBox(height: height * 0.02),
                    Container(
                      width: width * 0.7,
                      height: height * 0.07,
                      decoration: BoxDecoration(
                          color: const Color.fromARGB(255, 235, 235, 235),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GestureDetector(
                              onTap: () {
                                setState(() {
                                  shownumpad = true;
                                });
                              },
                              child: const BoxID()),
                          GestureDetector(
                            onTap: () {
                              if (shownumpad == false) {
                                setState(() {
                                  shownumpad = true;
                                });
                              } else {
                                setState(() {
                                  shownumpad = false;
                                });
                              }
                            },
                            child: SizedBox(
                              height: width * 0.08,
                              width: width * 0.08,
                              child: SvgPicture.asset(
                                'assets/Frame 9128.svg',
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Center(
                      child: Column(
                        children: [
                          SizedBox(
                              height:
                                  MediaQuery.of(context).size.height * 0.005),
                          shownumpad == true
                              ? Column(
                                  children: [
                                    idcard,
                                    SizedBox(height: height * 0.01),
                                    status == false
                                        ? GestureDetector(
                                            onTap: () {
                                              agreement();
                                            },
                                            child: BoxWidetdew(
                                                color: const Color(0xff00A3FF),
                                                height: 0.05,
                                                width: 0.3,
                                                text: 'ตกลง',
                                                radius: 10.0,
                                                textcolor: Colors.white,
                                                fontSize: 0.05))
                                        : SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.05,
                                            child:
                                                const CircularProgressIndicator(),
                                          ),
                                  ],
                                )
                              : SizedBox(
                                  height: height * 0.3,
                                  width: width * 0.5,
                                  child: Image.asset('assets/ppasc.png'),
                                )
                        ],
                      ),
                    ),

                    // ElevatedButton(
                    //     onPressed: () {
                    //       Get.toNamed('preparation_videocall');
                    //     },
                    //     child: const Text("videocal"))
                  ],
                )),
              ),
            ]),
          ))
        ],
      ),
    );
  }
}
