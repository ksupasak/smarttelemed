import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smarttelemed/apps/telemed/core/services/background.dart/background.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/openvidu/videocall.dart';
import 'package:smarttelemed/apps/telemed/views/station/summary.dart';
import 'package:smarttelemed/apps/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/apps/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/apps/telemed/views/station/userInformation.dart';

import 'package:smarttelemed/l10n/app_localizations.dart';

class WaitingApp extends StatefulWidget {
  const WaitingApp({super.key});

  @override
  State<WaitingApp> createState() => _WaitingAppState();
}

class _WaitingAppState extends State<WaitingApp> {
  Timer? timerCheck;
  var resToJson;
  var resToJsonVideo;
  bool bottonStatus = true;
  @override
  void initState() {
    checkfinished();

    super.initState();
  }

  @override
  void dispose() {
    timerCheck!.cancel();
    super.dispose();
  }

  void checkfinished() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("เช็คการสถานะการตรวจ");
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/check_quick',
    );
    var res = await http.post(
      url,
      body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      },
    );

    resToJson = json.decode(res.body);
    provider.debugPrintV("message :${resToJson["message"]}");
    if (resToJson["message"] == "finished") {
      provider.debugPrintV("การตรวจเสร็จสิ้น ${resToJson["message"]}");
      provider.debugPrintV("เลือกพิมพ์ผลหรือตรวจใหม่");
      setState(() {});
    } else {
      checkQuick();
    }
  }

  Future<void> checkQuick() async {
    DataProvider provider = context.read<DataProvider>();
    bool one = true;
    timerCheck = Timer.periodic(const Duration(seconds: 2), (timer) async {
      var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/check_quick',
      );
      var res = await http.post(
        url,
        body: {
          'care_unit_id': context.read<DataProvider>().care_unit_id,
          'public_id': context.read<DataProvider>().id,
        },
      );
      resToJson = json.decode(res.body);
      setState(() {});
      if (res.statusCode == 200) {
        // provider.debugPrintV("");
        // debugPrint(resToJson["message"]);
        if (resToJson["message"] == "waiting") {
          debugPrint("รอหมอเลียกตรวจ ${resToJson["message"]}");
          setState(() {
            one = true;
          });
        }
        if (resToJson["message"] == "processing") {
          debugPrint("หมอกำลังตรวจ ${resToJson["message"]}");
          if (one) {
            setState(() {
              one = false;
            });
            getvideocalldata();
          }
        }
        if (resToJson["message"] == "completed") {
          debugPrint("หมอกำลังลงผลตรวจ ${resToJson["message"]}");
          setState(() {
            one = true;
          });
        }
        if (resToJson["message"] == "finished") {
          debugPrint("การตรวจเสร็จสิ้น ${resToJson["message"]}");
          setState(() {
            one = true;
          });
          timerCheck!.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const Summary()),
          );
        }
      }
    });
  }

  Future<void> getvideocalldata() async {
    print("-------------");
    setState(() {
      bottonStatus = false;
    });
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/get_video',
    );
    var res = await http.post(
      url,
      body: {'public_id': context.read<DataProvider>().id},
    );
    resToJsonVideo = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        bottonStatus = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: resToJson != null
          ? resToJson["message"] == "waiting"
                ? splash_waiting(context)
                : resToJson["message"] == "processing"
                ? prepare(context)
                : resToJson["message"] == "completed"
                ? splash_completed(context)
                : resToJson["message"] == "finished"
                ? choice(context)
                : const Text("message error")
          : SizedBox(
              height: height,
              width: width,
              child: Center(
                child: Text(
                  AppLocalizations.of(context)!.waitting_loading,
                  //"Loading...",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
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
                      builder: (context) => const Userinformation(),
                    ),
                  );
                },
                child: Container(
                  height: height * 0.025,
                  width: width * 0.15,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color.fromARGB(255, 201, 201, 201),
                      width: width * 0.002,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      AppLocalizations.of(
                        context,
                      )!.waitting_backButton, // '< ย้อนกลับ',
                      style: TextStyle(
                        fontSize: width * 0.03,
                        color: const Color.fromARGB(255, 201, 201, 201),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget splash_waiting(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
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
          Positioned(
            bottom: 5,
            child: SizedBox(
              height: height * 0.4,
              width: width,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.waitting_waitting_doctor, //'รอหมอ',
                    style: TextStyle(fontSize: width * 0.1),
                  ),
                  const CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 139, 130),
                  ),
                  // Center(
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     const Userinformation()));
                  //       },
                  //       child: Padding(
                  //         padding: const EdgeInsets.all(8.0),
                  //         child: Container(
                  //           width: width * 0.1,
                  //           decoration: BoxDecoration(
                  //               border: Border.all(color: Colors.grey)),
                  //           child: Center(
                  //             child: Text(
                  //               AppLocalizations.of(context)!.leave,
                  //               style: TextStyle(
                  //                   color: Colors.red, fontSize: width * 0.03),
                  //             ),
                  //           ),
                  //         ),
                  //       )),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget prepare(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return resToJsonVideo == null
        ? SafeArea(
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
                Positioned(
                  bottom: 5,
                  child: SizedBox(
                    height: height * 0.4,
                    width: width,
                    child: Column(
                      children: [
                        Text(
                          AppLocalizations.of(
                            context,
                          )!.waitting_waitting_doctor, //'รอหมอ'
                          style: TextStyle(fontSize: width * 0.1),
                        ),
                        const CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 139, 130),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          )
        : resToJsonVideo["data"] != null
        ? VideocallWidget(
            server: 'openvidu.pcm-life.com',
            sessionId: resToJsonVideo["data"]["sessionId"],
            token: resToJsonVideo["data"]["token"],
            userName: "People",
            secret: "minadadmin",
            iceServer: "",
          )
        : Text(AppLocalizations.of(context)!.waitting_loading);
  }

  void add_appoint_today() async {
    DataProvider provider = context.read<DataProvider>();
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/add_appoint_today',
    );
    var res = await http.post(
      url,
      body: {'public_id': provider.id, 'care_unit_id': provider.care_unit_id},
    );
    var restojson = json.decode(res.body);
    if (res.statusCode == 200 || restojson["message"] == "success") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const WaitingApp()),
      );
    }
  }

  Widget splash_completed(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return SafeArea(
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
          Positioned(
            bottom: 5,
            child: SizedBox(
              width: width,
              height: height * 0.4,
              child: Column(
                children: [
                  Text(
                    AppLocalizations.of(
                      context,
                    )!.waitting_results, //'รอผลตรวจ',
                    style: TextStyle(fontSize: width * 0.1),
                  ),
                  const CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 139, 130),
                  ),
                  // Center(
                  //   child: GestureDetector(
                  //       onTap: () {
                  //         Navigator.pushReplacement(
                  //             context,
                  //             MaterialPageRoute(
                  //                 builder: (context) =>
                  //                     const Userinformation()));
                  //       },
                  //       child: Container(
                  //         width: width * 0.1,
                  //         decoration: BoxDecoration(
                  //             border: Border.all(color: Colors.grey)),
                  //         child: Center(
                  //           child: Text(
                  //             AppLocalizations.of(context)!.leave,
                  //             style: TextStyle(
                  //                 color: Colors.red, fontSize: width * 0.03),
                  //           ),
                  //         ),
                  //       )),
                  // )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget choice(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.read<DataProvider>();
    return Stack(
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
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: const Center(child: InformationCard()),
                ),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                  style: stylebutter(
                    Colors.blue,
                    width * provider.buttonSized_w,
                    height * provider.buttonSized_h,
                  ),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => const Summary()),
                    );
                  },
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.waitting_review, // "ดูผลตรวจ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                  style: stylebutter(
                    Colors.green,
                    width * provider.buttonSized_w,
                    height * provider.buttonSized_h,
                  ),
                  onPressed: () {
                    add_appoint_today();
                  },
                  child: Text(
                    AppLocalizations.of(
                      context,
                    )!.waitting_under_exam, //"ตรวจซ้ำ",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: width * 0.06,
                    ),
                  ),
                ),
              ),
              SizedBox(height: height * 0.02),
              // Center(
              //   child: GestureDetector(
              //       onTap: () {
              //         Navigator.pushReplacement(
              //             context,
              //             MaterialPageRoute(
              //                 builder: (context) => const Userinformation()));
              //       },
              //       child: Container(
              //         width: width * 0.1,
              //         decoration:
              //             BoxDecoration(border: Border.all(color: Colors.grey)),
              //         child: Center(
              //           child: Text(
              //             AppLocalizations.of(context)!.leave,
              //             style: TextStyle(
              //                 color: Colors.red, fontSize: width * 0.03),
              //           ),
              //         ),
              //       )),
              // )
            ],
          ),
        ),
      ],
    );
  }
}
