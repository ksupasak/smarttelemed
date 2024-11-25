import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/setting/setting.dart';
import 'package:smarttelemed/telemed/views/ui/numpad.dart';

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
  Timer? checkcardout;
  bool shownumpad = false, status = false;
  var resTojsonGateway;
  var resTojson_getIdCard;
  var resTojson_esm;
  String texthead = '';
  @override
  void initState() {
    clearProvider();
    getIdCard();

    super.initState();
  }

  void clearProvider() {
    DataProvider provider = context.read<DataProvider>();
    provider.id = '';
    provider.lname = '';
    provider.fname = '';
    provider.prefixName = '';
    provider.phone = '';
    provider.hn = '';
    provider.vn = '';
    provider.age = '';
    provider.imgae = '';
    provider.birthdate = '';
    provider.claimCode = '';
    provider.correlationId = '';
    provider.claimType = '';
    provider.claimTypeName = '';
  }

  @override
  void dispose() {
    timerreadIDCard!.cancel();
    super.dispose();
  }

  void getIdCard() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("Start Card Reader--------------------------------=");
    timerreadIDCard = Timer.periodic(const Duration(seconds: 3), (timer) async {
      try {
        var url = Uri.parse('http://localhost:8189/api/smartcard/read');
        var res = await http.get(url);
        resTojson_getIdCard = json.decode(res.body);
        debugPrint("Carde= Reader--------------------------------=");
        if (res.statusCode == 200) {
          provider.debugPrintV("บันทึกข้อมูลจาก CardลงProvider");
          provider.updateuserinformation(resTojson_getIdCard);
          provider
              .debugPrintV("Stop Card Reader--------------------------------=");
          if (!provider.require_VN) {
            provider.debugPrintV("!provider.require_VN ");
            //   provider.updateuserCard(resTojson_getIdCard);
            setState(() {
              status = true;
            });
          }
          sendvisitGateway();
        } else if (res.statusCode == 500) {
          // provider.debugPrintV(res.statusCode.toString());
          // provider.debugPrintV("${resTojson_getIdCard['error']}");
          setState(() {
            texthead = '';
          });
        } else {
          debugPrint("${resTojson_getIdCard['error']}");
        }
      } catch (e) {
        provider.debugPrintV(
            "Error Carde= Reader http://localhost:8189/api/smartcard/read");
      }
    });
  }

  void sendvisitGateway() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("sendvisitGateway");
    if (provider.id.length == 13) {
      try {
        var url = Uri.parse(
            '${provider.platfromURLGateway}/api/patient?cid=${provider.id}');
        provider.debugPrintV(
            "senvisitGateway :${provider.platfromURLGateway}/api/patient?cid=${provider.id}");
        var response = await http.get(url);
        provider.debugPrintV("response $response");
        resTojsonGateway = json.decode(response.body);
      } catch (e) {
        provider.debugPrintV("error senvisitGateway $e");
        provider.debugPrintV("ข้ามการอ่านข้อมูลผ่านGateway");
        provider.debugPrintV(
            "get ข้อมูลจากบัตรประชน เปลี่ยนเป็นขอมูลจำรอง gateway");
        String databirthDate = resTojson_getIdCard['birthDate'];
        String birthdate =
            "${databirthDate[0]}${databirthDate[1]}${databirthDate[2]}${databirthDate[3]}-${databirthDate[4]}${databirthDate[5]}-${databirthDate[6]}${databirthDate[7]}";
        Map data = {
          "data": {
            "hn": "123456",
            "vn": "Text1234",
            "prefix_name": "",
            "fname": resTojson_getIdCard['fname'],
            "lname": resTojson_getIdCard['lname'],
            "phone": "0987654321",
            "birthdate": birthdate
          }
        };
        provider.updateusergateway(data);

        sendId();
      } finally {
        //   client.close();
        // provider.debugPrintV("ปิด client https");
      }
      provider.debugPrintV("resTojsonGateway ${resTojsonGateway.toString()}");

      if (resTojsonGateway != null) {
        if (resTojsonGateway["statuscode"] == 400 ||
            resTojsonGateway["statuscode"] == 404) {
          provider.debugPrintV("statuscode 400||404 ไม่ข้อมีมูลในระบบ ไม่มีHN");
          setState(() {
            texthead = S.of(context)!.hn + provider.text_no_hn;
          });
        }
        if (resTojsonGateway["statuscode"] == 100) {
          provider.updateusergateway(resTojsonGateway);
          if (resTojsonGateway["data"]["vn"] != null &&
              resTojsonGateway["data"]["vn"] != "") {
            provider.debugPrintV("statuscode 100 มี VN ");
            sendId();
          } else if (resTojsonGateway["data"]["vn"] == null ||
              resTojsonGateway["data"]["vn"] == "") {
            setState(() {
              if (provider.require_VN) {
                texthead = S.of(context)!.no_vn + provider.text_no_vn;
                provider.debugPrintV("ไม่มี VN ติดต่อเจ้าหน้าที่ ");
              }
            });
            if (!provider.require_VN) {
              timerreadIDCard?.cancel();
              provider.debugPrintV("อนุญาติให้เข้าระบบเเบไม่มีVN");
              sendId();
            }
          }
        }
      }
    } else {
      provider.debugPrintV("เลขบัตรประชาชนไม่ครบ");
      setState(() {
        status = false;
      });
    }
  }

  void sendId() async {
    DataProvider provider = context.read<DataProvider>();
    setState(() {
      status = true;
    });
    provider.debugPrintV(
        "sen get_patient ESM :${provider.platfromURL}/get_patient");
    try {
      var url = Uri.parse('${provider.platfromURL}/get_patient');
      var res = await http.post(url, body: {
        'care_unit_id': provider.care_unit_id,
        'public_id': provider.id,
      });
      resTojson_esm = json.decode(res.body);
    } catch (e) {
      provider.debugPrintV(
          " error sen get_patient ESM :${provider.platfromURL}/get_patient :$e");
    }
    provider
        .debugPrintV("resTojson get_patient ESM ${resTojson_esm.toString()}");
    setState(() {
      status = false;
    });
    if (resTojson_esm['message'] == 'not found') {
      provider.debugPrintV("ไม่มีข้อมูลในระบบESM");
      if (provider.hn != "" && provider.phone != "") {
        provider.debugPrintV("สมัคข้อมูลในESM Auto");
        provider.debugPrintV("public_id ${provider.id} ");
        provider.debugPrintV("prefix_name ${provider.prefixName} ");
        provider.debugPrintV("first_name ${provider.fname} ");
        provider.debugPrintV("Hlast_name ${provider.lname} ");
        provider.debugPrintV("tel ${provider.phone} ");
        provider.debugPrintV("HN ${provider.hn} ");
        provider.debugPrintV("picture64 ${provider.imgae} ");
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
          timerreadIDCard?.cancel();
          checkcardout?.cancel;
          setState(() {
            status = false;
          });
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Userinformation()));
          });
        }
      } else {
        provider.debugPrintV("ไม่มี HN หรือ ไม่มี phone");
        setState(() {
          status = false;
        });
        //ไปหน้าสมัค
      }
    } else {
      setState(() {
        status = false;
      });
      timerreadIDCard?.cancel();
      checkcardout?.cancel;
      provider.debugPrintV("มีข้อมูลในระบบESM");
      provider
          .debugPrintV("เช็คข้อมูลในprovider เพิ่มข้อมูลในกรณีที่เป็นค่าว่าง");
      if (provider.fname == "") {
        if (resTojson_esm["data"]["first_name"] != null) {
          provider.fname = resTojson_esm["data"]["first_name"];
          provider.debugPrintV("fname =='' เพิ่ม fname ลง provider");
        } else {
          provider.debugPrintV("ในระบบESMไม่มี first_name");
        }
      }
      if (provider.lname == "") {
        if (resTojson_esm["data"]["last_name"] != null) {
          provider.lname = resTojson_esm["data"]["last_name"];
          provider.debugPrintV("lname =='' เพิ่ม lname ลง provider");
        } else {
          provider.debugPrintV("ในระบบESMไม่มี last_name");
        }
      }
      if (provider.hn == "") {
        if (resTojson_esm["data"]["hn"] != null) {
          provider.hn = resTojson_esm["data"]["hn"];
          provider.debugPrintV("HN =='' เพิ่ม HN ลง provider");
        } else {
          provider.debugPrintV("ในระบบESMไม่มี HN");
        }
      }
      if (provider.phone == "") {
        if (resTojson_esm["data"]["tal"] != null) {
          provider.phone = resTojson_esm["data"]["tal"];
          provider.debugPrintV("phone =='' เพิ่ม phone ลง provider");
        } else {
          provider.debugPrintV("ในระบบESMไม่มี phone");
        }
      }

      Timer(const Duration(seconds: 1), () {
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
                    child: ListView(
                      //   mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Center(
                          child: SizedBox(
                            width: width * 0.35,
                            height: width * 0.35,
                            child: SvgPicture.asset('assets/splash/logo.svg'),
                          ),
                        ),
                        Center(
                          child: Text(
                            "กรุณาเสียบบัตรประชาชนหรือ เเสกน HN เพื่อทำรายการต่อ",
                            style: TextStyle(
                                fontSize: width * 0.035,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                        Center(
                          child: Text(
                            texthead,
                            style: TextStyle(
                                color: Colors.red, fontSize: width * 0.03),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Center(
                          child: Container(
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
                        ),
                        SizedBox(height: height * 0.005),
                        Column(
                          children: [
                            Numpad(),
                            SizedBox(height: height * 0.02),
                            status == false
                                ? ElevatedButton(
                                    style: stylebutter(
                                        !provider.requirel_id_card
                                            ? Colors.green
                                            : Colors.grey,
                                        width * 0.4,
                                        height * 0.08),
                                    onPressed: () {
                                      if (!provider.requirel_id_card) {
                                        sendvisitGateway();
                                      } else {
                                        provider.debugPrintV(
                                            "การตั่งค่าปังคับใช้บัตรเปิดอยู่");
                                      }
                                    },
                                    child: Text(
                                      S.of(context)!.confirm,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: width * 0.06),
                                    ))
                                : SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.05,
                                    height: MediaQuery.of(context).size.width *
                                        0.05,
                                    child: const CircularProgressIndicator(),
                                  ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              height: height * 0.15,
                              width: width * 0.35,
                              child: Image.asset('assets/ppasc.png'),
                            ),
                            SizedBox(
                              height: height * 0.15,
                              width: width * 0.35,
                              child: Image.asset('assets/Frame.png'),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.fromLTRB(0, 0, 50, 0),
                              child: SizedBox(
                                height: height * 0.1,
                                width: width * 0.05,
                                child: Image.asset(
                                  'assets/pngtree.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            bottom: 5,
            left: 5,
            child: SizedBox(
              width: width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        if (provider.password == provider.id) {
                          timerreadIDCard?.cancel();
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Setting()));
                          provider.debugPrintV('Setting');
                        }
                      },
                      child: Container(
                          color: Colors.white,
                          child: Text(
                            "ตั้งค่า",
                            style: TextStyle(fontSize: width * 0.03),
                          ))),
                  GestureDetector(
                      onTap: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return Scaffold(
                                appBar: AppBar(),
                                body: Container(
                                  height: height * 0.8,
                                  child: ListView.builder(
                                      itemCount: context
                                          .read<DataProvider>()
                                          .debug
                                          .length,
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
                      child: Container(
                          color: Colors.white, child: const Text("log"))),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
