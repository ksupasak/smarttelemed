import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/setting/ui/numpad.dart';
import 'package:smarttelemed/telemed/views/ui/popup.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class HomeTelemed extends StatefulWidget {
  const HomeTelemed({super.key});

  @override
  State<HomeTelemed> createState() => _HomeTelemedState();
}

class _HomeTelemedState extends State<HomeTelemed> {
  Timer? timerreadIDCard;
  bool shownumpad = false, status = false;

  @override
  void initState() {
    //  getIdCard();
    context.read<DataProvider>().id = '';
    super.initState();
  }

  @override
  void dispose() {
    timerreadIDCard!.cancel();
    super.dispose();
  }

  void getIdCard() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("Start Crde Reader--------------------------------=");
    timerreadIDCard = Timer.periodic(const Duration(seconds: 1), (timer) async {
      var url = Uri.parse('http://localhost:8189/api/smartcard/read');
      var res = await http.get(url);
      var resTojson = json.decode(res.body);
      debugPrint("Crde Reader--------------------------------=");
      if (res.statusCode == 200) {
        context.read<DataProvider>().updateuserinformation(resTojson);
        timerreadIDCard?.cancel();
        provider
            .debugPrintV("Stop Crde Reader--------------------------------=");
        senvisitGateway();
      }
    });
  }

  void senvisitGateway() async {
    DataProvider provider = context.read<DataProvider>();
    if (provider.id.length == 13) {
      provider.debugPrintV(
          "senvisitGateway :${provider.platfromURLgeatway}/api/patient?cid=${provider.id}");
      var url = Uri.parse(
          '${provider.platfromURLgeatway}/api/patient?cid=${provider.id}');
      var res = await http.get(url);
      var resTojsonGateway = json.decode(res.body);
      debugPrint(resTojsonGateway.toString());
      if (resTojsonGateway != null) {
        if (resTojsonGateway["statuscode"] == 400 ||
            resTojsonGateway["statuscode"] == 404) {
          provider.debugPrintV("ไม่มี VN ติดต่อเจ้าหน้าที่ ");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Popup(
                  texthead: S.of(context)!.no_hn,
                  textbody: provider.text_no_hn,
                  buttonbar: [
                    ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(S.of(context)!.leave))
                  ],
                );
              });
        }
        if (resTojsonGateway["statuscode"] == 100) {
          provider.debugPrintV("มี VN ");
          provider.updateusergateway(resTojsonGateway);
          senId();
        }
      }
    } else {
      provider.debugPrintV("เลขบัตรประชาชนไม่ครบ");

      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'เลขบัตรประชาชนไม่ครบ',
              textbody: 'กรุณากรองเลขบัตรประชาชนไห้ครบ',
              pathicon: 'assets/warning (1).png',
              buttonbar: [
                ElevatedButton(
                    style: stylebutter(Colors.white),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(S.of(context)!.leave))
              ],
            );
          });
      setState(() {
        status = false;
      });
    }
  }

  void senId() async {
    DataProvider provider = context.read<DataProvider>();
    setState(() {
      status = true;
    });

    provider.debugPrintV(
        "sen get_patient ESM :${provider.platfromURL}/get_patient");
    var url = Uri.parse('${provider.platfromURL}/get_patient');
    var res = await http.post(url, body: {
      'care_unit_id': provider.care_unit_id,
      'public_id': provider.id,
    });
    var resTojson = json.decode(res.body);
    provider.debugPrintV("resTojson get_patient ${resTojson.toString()}");
    setState(() {
      status = false;
    });
    if (resTojson['message'] == 'not found') {
      provider.debugPrintV("ไม่มีข้อมูลในระบบESM");
      provider.debugPrintV("กำลังสมัคข้อมูลในESM");
      var url = Uri.parse('${provider.platfromURL}/add_patient');
      var res = await http.post(url, body: {
        'care_unit_id': provider.care_unit_id,
        'public_id': provider.id,
        'prefix_name': provider.prefixName,
        'first_name': provider.fname,
        'last_name': provider.lname,
        'tel': provider.phone,
        'hn': provider.hn,
        'picture64': provider.imgae,
      });
      var resTojson = json.decode(res.body);
      if (res.statusCode == 200) {
        provider.debugPrintV("สมัคข้อมูลในESMสำเร็จ");
        provider.debugPrintV("StatusresTojson :${resTojson["message"]}");
      }
      if (resTojson["message"] == "success") {
        Future.delayed(const Duration(seconds: 1), () {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Userinformation()));
        });
      }
    } else {
      provider.debugPrintV("มีข้อมูลในระบบESM");
      Timer(const Duration(seconds: 1), () {
        timerreadIDCard?.cancel();
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Userinformation()));
          });
        });
      });
    }
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
          Positioned(
            child: SizedBox(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                      shownumpad = !shownumpad;
                                    });
                                  },
                                  child: const BoxID()),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        shownumpad == true
                            ? Column(
                                children: [
                                  Numpad(),
                                  SizedBox(height: height * 0.01),
                                  status == false
                                      ? ElevatedButton(
                                          style: stylebutter(
                                              !provider.requirel_id_card
                                                  ? Colors.green
                                                  : Colors.grey),
                                          onPressed: () {
                                            if (!provider.requirel_id_card) {
                                              senvisitGateway();
                                            } else {
                                              provider.debugPrintV(
                                                  "การตั่งค่าปังคับใช้บัตรเปิดอยู่");
                                            }
                                          },
                                          child: Text(
                                            S.of(context)!.confirm,
                                            style: const TextStyle(
                                                color: Colors.white),
                                          ))
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
