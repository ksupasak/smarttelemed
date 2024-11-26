import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/views/healthrecord.dart';
import 'package:smarttelemed/telemed/views/home.dart';
import 'package:smarttelemed/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/telemed/views/ui/popup.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:smarttelemed/telemed/views/waiting.dart';

class Userinformation extends StatefulWidget {
  const Userinformation({super.key});

  @override
  State<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends State<Userinformation> {
  bool button = false;
  String birthdate(String datas) {
    if (datas != "") {
      return "${datas[8]}${datas[9]}/${datas[5]}${datas[6]}/${datas[0]}${datas[1]}${datas[2]}${datas[3]}";
    } else {
      return "";
    }
  }

  void checkhealthrecord() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("checkhealthrecord");
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_hr_today');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    var resToJson = json.decode(res.body);

    if (res.statusCode == 200) {
      if (resToJson["health_records"].length != 0) {
        provider
            .debugPrintV("มี health_records :${resToJson["health_records"]}");
        setState(() {
          button = true;
        });
      } else {
        provider.debugPrintV(
            "ไม่มี health_records :${resToJson["health_records"]}");
        setState(() {
          button = false;
        });
      }
    }
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
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("ยกเลิก",
                        style: TextStyle(fontSize: 20, color: Colors.red))),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      shadowColor: Colors.green,
                      backgroundColor: Colors.green,
                      elevation: 5,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const WaitingApp()));
                    },
                    child: const Text(
                      "ตกลง",
                      style: TextStyle(fontSize: 32, color: Colors.white),
                    ))
              ],
            );
          });
    }
  }

  @override
  void initState() {
    checkhealthrecord();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.read<DataProvider>();
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SizedBox(
            width: width,
            height: height,
            child: ListView(
              children: [
                SizedBox(height: height * 0.13),
                Center(
                  child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 0.5,
                              color: Color(0xff48B5AA),
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: const Center(
                        child: InformationCard(),
                      )),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: Container(
                    width: width * 0.8,
                    height: height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Color.fromARGB(255, 188, 188, 188),
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Center(
                      child: provider.claimType != ""
                          ? Text(
                              "${provider.claimTypeName} (${provider.claimType})",
                              style: TextStyle(fontSize: width * 0.03))
                          : Text(S.of(context)!.no_treatment_rights,
                              style: TextStyle(fontSize: width * 0.03)),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Center(
                  child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Color.fromARGB(255, 188, 188, 188),
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Column(
                          children: [
                            Text(S.of(context)!.check_data,
                                style: TextStyle(fontSize: width * 0.04)),
                            provider.vn == ""
                                ? Text(
                                    provider.text_no_vn,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: width * 0.03),
                                  )
                                : const Text(""),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(S.of(context)!.id_card_number,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(S.of(context)!.full_name,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(S.of(context)!.birth_date,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text("อายุ",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(S.of(context)!.hn,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(S.of(context)!.phone_number,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(context.watch<DataProvider>().id,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(
                                          "${provider.fname}  ${provider.lname}",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(birthdate(provider.birthdate),
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(provider.age,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(provider.hn,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(provider.phone,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02)
                          ],
                        ),
                      )),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: ElevatedButton(
                      style: stylebutter(
                          Colors.green,
                          width * provider.buttonSized_w,
                          height * provider.buttonSized_h),
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SumHealthrecord()));
                      },
                      child: Text(S.of(context)!.health_check,
                          style: TextStyle(
                              fontSize: width * 0.06, color: Colors.white))),
                ),
                SizedBox(height: height * 0.02),
                Center(
                    child: ElevatedButton(
                        style: stylebutter(
                            button ? Colors.blue : Colors.grey,
                            width * provider.buttonSized_w,
                            height * provider.buttonSized_h),
                        onPressed: () {
                          if (button) {
                            agreement();
                          }
                        },
                        child: Text(S.of(context)!.enter_exam,
                            style: TextStyle(
                                fontSize: width * 0.06, color: Colors.white)))),
                !button
                    ? Center(
                        child: Text(
                          "(กรุณาตรวจสุขภาพก่อน)",
                          style: TextStyle(
                              color: const Color.fromARGB(145, 244, 67, 54),
                              fontSize: width * 0.03),
                        ),
                      )
                    : const Text(""),
                SizedBox(height: height * 0.03),
                // Center(
                //   child: GestureDetector(
                //       onTap: () {
                //         Navigator.pushReplacement(
                //             context,
                //             MaterialPageRoute(
                //                 builder: (context) => const HomeTelemed()));
                //       },
                //       child: Container(
                //         width: width * 0.1,
                //         decoration: BoxDecoration(
                //             border: Border.all(color: Colors.grey)),
                //         child: Center(
                //           child: Text(
                //             S.of(context)!.leave,
                //             style: TextStyle(
                //                 color: Colors.red, fontSize: width * 0.035),
                //           ),
                //         ),
                //       )),
                // )
              ],
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: GestureDetector(
                onTap: () {
                  showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return Scaffold(
                          appBar: AppBar(),
                          body: Container(
                            height: height * 0.8,
                            child: ListView.builder(
                                itemCount:
                                    context.read<DataProvider>().debug.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                        "$index ${context.read<DataProvider>().debug[index]}"),
                                  );
                                }),
                          ),
                        );
                      });
                },
                child:
                    Container(color: Colors.white, child: const Text("log"))),
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
