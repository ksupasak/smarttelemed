import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smarttelemed/myapp/widgetdew.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/views/openvidu/videocall.dart';
import 'package:smarttelemed/telemed/views/summary.dart';
import 'package:smarttelemed/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/check_quick');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });

    resToJson = json.decode(res.body);
    if (resToJson["message"] == "finished") {
      debugPrint("การตรวจเสร็จสิ้น ${resToJson["message"]}");
      debugPrint("เลือกพิมพ์ผลหรือตรวจใหม่");
      setState(() {});
    } else {
      checkQuick();
    }
  }

  Future<void> checkQuick() async {
    DataProvider provider = context.read<DataProvider>();

    timerCheck = Timer.periodic(const Duration(seconds: 2), (timer) async {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_quick');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      resToJson = json.decode(res.body);
      setState(() {});
      if (res.statusCode == 200) {
        // provider.debugPrintV("");
        // debugPrint(resToJson["message"]);
        if (resToJson["message"] == "waiting") {
          debugPrint("รอหมอเลียกตรวจ ${resToJson["message"]}");
        }
        if (resToJson["message"] == "processing") {
          debugPrint("หมอกำลังตรวจ ${resToJson["message"]}");
        }
        if (resToJson["message"] == "completed") {
          debugPrint("หมอกำลังลงผลตรวจ ${resToJson["message"]}");
        }
        if (resToJson["message"] == "finished") {
          debugPrint("การตรวจเสร็จสิ้น ${resToJson["message"]}");
          timerCheck!.cancel();
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Summary()));
        }
      }
    });
  }

  Future<void> getvideocalldata() async {
    setState(() {
      bottonStatus = false;
    });
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    resToJsonVideo = json.decode(res.body);
    if (res.statusCode == 200) {
      setState(() {
        bottonStatus = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
                          : null
          : const Text("Loading..."),
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
          Positioned(
            bottom: 5,
            child: SizedBox(
              height: height * 0.4,
              width: width,
              child: Column(
                children: [
                  Text('รอหมอ', style: TextStyle(fontSize: width * 0.1)),
                  const CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 139, 130),
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Userinformation()));
                        },
                        child: Container(
                          width: width * 0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                              S.of(context)!.leave,
                              style: TextStyle(
                                  color: Colors.red, fontSize: width * 0.03),
                            ),
                          ),
                        )),
                  )
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
                const backgrund(),
                Positioned(
                    child: ListView(
                  children: [
                    SizedBox(height: height * 0.15),
                    const Center(child: Text("เตรียมตัว")),
                    Center(
                      child: Container(
                        height: width * 0.5,
                        width: width * 0.5,
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.grey)),
                      ),
                    ),
                    const Icon(Icons.camera),
                    const Icon(Icons.mic),
                    Center(
                      child: bottonStatus
                          ? ElevatedButton(
                              style: stylebutter(Colors.blue),
                              onPressed: () {
                                getvideocalldata();
                              },
                              child: Text(
                                "เข้าห้องสนทนา",
                                style: TextStyle(
                                    fontSize: width * 0.03,
                                    color: Colors.white),
                              ))
                          : const CircularProgressIndicator(
                              color: Color.fromARGB(255, 0, 139, 130),
                            ),
                    )
                  ],
                ))
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
            : const Text("Loading...");
  }

  void add_appoint_today() async {
    DataProvider provider = context.read<DataProvider>();
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/add_appoint_today');
    var res = await http.post(url, body: {
      'public_id': provider.id,
      'care_unit_id': provider.care_unit_id,
    });
    var restojson = json.decode(res.body);
    if (res.statusCode == 200 || restojson["message"] == "success") {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const WaitingApp()));
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
          Positioned(
            bottom: 5,
            child: SizedBox(
              width: width,
              height: height * 0.4,
              child: Column(
                children: [
                  Text('รอผลตรวจ', style: TextStyle(fontSize: width * 0.1)),
                  const CircularProgressIndicator(
                    color: Color.fromARGB(255, 0, 139, 130),
                  ),
                  Center(
                    child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const Userinformation()));
                        },
                        child: Container(
                          width: width * 0.1,
                          decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey)),
                          child: Center(
                            child: Text(
                              S.of(context)!.leave,
                              style: TextStyle(
                                  color: Colors.red, fontSize: width * 0.03),
                            ),
                          ),
                        )),
                  )
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
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: const Center(
                      child: InformationCard(),
                    )),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                    style: stylebutter(Colors.blue),
                    onPressed: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Summary()));
                    },
                    child: Text(
                      "ดูผลตรวจ",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.03),
                    )),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: ElevatedButton(
                    style: stylebutter(Colors.green),
                    onPressed: () {
                      add_appoint_today();
                    },
                    child: Text(
                      "ตรวจซ้ำ",
                      style: TextStyle(
                          color: Colors.white, fontSize: width * 0.03),
                    )),
              ),
              SizedBox(height: height * 0.02),
              Center(
                child: GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Userinformation()));
                    },
                    child: Container(
                      width: width * 0.1,
                      decoration:
                          BoxDecoration(border: Border.all(color: Colors.grey)),
                      child: Center(
                        child: Text(
                          S.of(context)!.leave,
                          style: TextStyle(
                              color: Colors.red, fontSize: width * 0.03),
                        ),
                      ),
                    )),
              )
            ],
          ),
        )
      ],
    );
  }
}
