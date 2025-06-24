import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/telemed/core/services/background.dart/background.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/setting/setting.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_register.dart';
import 'package:smarttelemed/apps/telemed/views/ui/numpad.dart';

import 'package:smarttelemed/apps/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/apps/telemed/views/station/patient_home.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';

class HomeTelemed extends StatefulWidget {
  const HomeTelemed({super.key});

  @override
  State<HomeTelemed> createState() => _HomeTelemedState();
}

class _HomeTelemedState extends State<HomeTelemed> {
  final FocusNode _focusNode = FocusNode();
  TextEditingController scanHn = TextEditingController();
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
    _focusNode.dispose();
    super.dispose();
  }

  void getIdCard() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("Start Card Reader--------------------------------=");
    timerreadIDCard = Timer.periodic(const Duration(seconds: 4), (timer) async {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _focusNode.requestFocus();
      });
      setState(() {
        scanHn.text = "";
      });
      try {
        var url = Uri.parse('http://localhost:8189/api/smartcard/read');
        var res = await http.get(url);
        resTojson_getIdCard = json.decode(res.body);
        debugPrint("Carde= Reader--------------------------------=");
        if (res.statusCode == 200) {
          provider.debugPrintV("บันทึกข้อมูลจาก CardลงProvider");
          provider.updateuserinformation(resTojson_getIdCard);
          provider.debugPrintV(
            "Stop Card Reader--------------------------------=",
          );
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
          "Error Carde= Reader http://localhost:8189/api/smartcard/read",
        );
      }
    });
  }

  void sendvisitGateway() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("sendvisitGateway");
    if (provider.id.length == 13) {
      try {
        var url = Uri.parse(
          '${provider.platfromURLGateway}/api/patient?cid=${provider.id}',
        );
        provider.debugPrintV(
          "senvisitGateway1 :${provider.platfromURLGateway}/api/patient?cid=${provider.id}",
        );
        var response = await http.get(url);
        provider.debugPrintV("response $response");
        resTojsonGateway = json.decode(response.body);
        // provider.debugPrintV("resTojsonGateway ลง provider$resTojsonGateway");
      } catch (e) {
        provider.debugPrintV("error senvisitGateway $e");
        sendId();
      }
      provider.debugPrintV("resTojsonGateway ${resTojsonGateway.toString()}");

      if (resTojsonGateway != null) {
        if (resTojsonGateway["statuscode"] == 400 ||
            resTojsonGateway["statuscode"] == 404) {
          provider.debugPrintV(
            "statuscode 400||404 ไม่ข้อมีมูลในระบบ ไม่มี HN",
          );
          setState(() {
            texthead = AppLocalizations.of(context)!.hn + provider.text_no_hn;
            status = false;
          });
        }
        if (resTojsonGateway["statuscode"] == 100) {
          provider.debugPrintV("เพิ่มข้อมูลจากgatewayลงprovider");
          provider.updateusergateway(resTojsonGateway);
          if (resTojsonGateway["data"]["vn"] != null &&
              resTojsonGateway["data"]["vn"] != "") {
            provider.debugPrintV("statuscode 100 มี VN ");
            sendId();
          } else if (resTojsonGateway["data"]["vn"] == null ||
              resTojsonGateway["data"]["vn"] == "") {
            setState(() {
              if (provider.require_VN) {
                texthead =
                    AppLocalizations.of(context)!.no_vn + provider.text_no_vn;
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
      sendvisitGatewayHn();
    }
  }

  void sendvisitGatewayHn() async {
    DataProvider provider = context.read<DataProvider>();
    provider.debugPrintV("sendvisitGatewayHN");

    setState(() {
      status = true;
    });

    try {
      var url = Uri.parse(
        '${provider.platfromURLGateway}/api/patient?hn=${provider.id}',
      );
      provider.debugPrintV(
        "senvisitGateway :${provider.platfromURLGateway}/api/patient?hn=${provider.id}",
      );
      var response = await http.get(url);
      provider.debugPrintV("response $response");
      resTojsonGateway = json.decode(response.body);
      // provider.debugPrintV("resTojsonGateway ลง provider$resTojsonGateway");
    } catch (e) {
      texthead =
          "error ${provider.platfromURLGateway}/api/patient?hn=${provider.id}";

      Future.delayed(const Duration(seconds: 5), () {
        texthead = "";
        provider.id = "";
      });
      provider.debugPrintV(
        "error ${provider.platfromURLGateway}/api/patient?hn=${provider.id} : $e",
      );
    }
    provider.debugPrintV("resTojsonGatewayHN ${resTojsonGateway.toString()}");
    if (resTojsonGateway != null) {
      if (resTojsonGateway["statuscode"] == 400 ||
          resTojsonGateway["statuscode"] == 404) {
        provider.debugPrintV("statuscode 400||404 ไม่ข้อมีมูลในระบบ ไม่มีHN");
        setState(() {
          texthead = AppLocalizations.of(context)!.hn + provider.text_no_hn;
          status = false;
        });
      }
      if (resTojsonGateway["statuscode"] == 100) {
        provider.debugPrintV("เพิ่มข้อมูลจากgatewayHNลงprovider");
        provider.updateusergateway(resTojsonGateway);
        if (resTojsonGateway["data"]["vn"] != null &&
            resTojsonGateway["data"]["vn"] != "") {
          provider.debugPrintV("statuscode 100 มี VN ");
          sendId();
        } else if (resTojsonGateway["data"]["vn"] == null ||
            resTojsonGateway["data"]["vn"] == "") {
          setState(() {
            if (provider.require_VN) {
              texthead =
                  AppLocalizations.of(context)!.no_vn + provider.text_no_vn;
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
    setState(() {
      status = false;
    });
  }

  void sendId() async {
    DataProvider provider = context.read<DataProvider>();
    setState(() {
      status = true;
    });
    provider.debugPrintV(
      "send get_patient ESM :${provider.platfromURL}/get_patient",
    );
    try {
      var url = Uri.parse('${provider.platfromURL}/get_patient');
      var res = await http.post(
        url,
        body: {'care_unit_id': provider.care_unit_id, 'public_id': provider.id},
      );
      resTojson_esm = json.decode(res.body);
      print(resTojson_esm);
      if (resTojson_esm['calendar_url'] != null) {
        provider.calendar_url = resTojson_esm['calendar_url'];
      }
      if (resTojson_esm['health_url'] != null) {
        provider.health_url = resTojson_esm['health_url'];
      }
    } catch (e) {
      provider.debugPrintV(
        " error send get_patient ESM :${provider.platfromURL}/get_patient :$e",
      );
    }
    provider.debugPrintV(
      "resTojson get_patient ESM ${resTojson_esm.toString()}",
    );
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
        var res = await http.post(
          url,
          body: {
            'care_unit_id': provider.care_unit_id,
            'public_id': provider.id,
            'prefix_name': provider.prefixName,
            'first_name': provider.fname,
            'last_name': provider.lname,
            'tel': provider.phone,
            'hn': provider.hn,
            'birth_date': provider.birthdate,
            'picture64': provider.imgae,
          },
        );
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
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const PatientHome()),
            // );
            context.read<DataProvider>().setPage(Stage.PATIENT_HOME_SCREEN);
          });
        }
      } else {
        provider.debugPrintV("ไม่มี HN หรือ ไม่มี phone");
        setState(() {
          status = false;
          timerreadIDCard?.cancel();
          checkcardout?.cancel;
        });
        context.read<DataProvider>().setPage(Stage.PATIENT_REGISTER_SCREEN);

        // Navigator.pushReplacement(
        //   context,
        //   MaterialPageRoute(builder: (context) => const PatientRegister()),
        // );
      }
    } else {
      timerreadIDCard?.cancel();
      checkcardout?.cancel;
      provider.debugPrintV("มีข้อมูลในระบบESM");
      provider.debugPrintV(
        "เช็คข้อมูลในprovider เพิ่มข้อมูลในกรณีที่เป็นค่าว่าง",
      );
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
        if (resTojson_esm["data"]["tel"] != null) {
          provider.phone = resTojson_esm["data"]["tel"];
          provider.debugPrintV("phone =='' เพิ่ม phone ลง provider");
        } else {
          provider.debugPrintV("ในระบบESMไม่มี phone");
        }
      }
      //
      provider.debugPrintV("ตรวจสอบวันเกิด");
      if (resTojson_esm["data"]["birth_date"] == null ||
          resTojson_esm["data"]["birth_date"] == "") {
        provider.debugPrintV("ไม่มีวันเกิดในESM");
        if (provider.birthdate != "") {
          provider.debugPrintV("มีวันเกิดในprovider");
          try {
            var url = Uri.parse("${provider.platfromURL}/add_patient");
            var res = await http.post(
              url,
              body: {
                'care_unit_id': provider.care_unit_id,
                'public_id': provider.id,
                'prefix_name': provider.prefixName,
                'first_name': provider.fname,
                'last_name': provider.lname,
                'tel': provider.phone,
                'hn': provider.hn,
                'birth_date': provider.birthdate,
                'picture64': provider.imgae,
              },
            );
            var resTojson = json.decode(res.body);
            if (res.statusCode == 200) {
              provider.debugPrintV("StatusresTojson :${resTojson["message"]}");
              if (resTojson['message'] == 'success') {
                provider.debugPrintV("Update สำเร็จ");
              }
            }
          } catch (e) {
            provider.debugPrintV("Update Error: $e");
          }
        } else {
          provider.debugPrintV("ไม่มีวันเกิดในprovider");
        }
      } else {
        provider.debugPrintV("มีวันเกิดในESM");
      }

      if (provider.calendar_url == '') {
        provider.debugPrintV("ไม่มีข้อมูลปฏิทิน");
      } else {
        provider.debugPrintV("มีข้อมูลปฏิทิน");
      }

      //
      setState(() {
        status = false;
      });

      Timer(const Duration(seconds: 1), () {
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            // Navigator.pushReplacement(
            //   context,
            //   MaterialPageRoute(builder: (context) => const PatientHome()),
            // );
            context.read<DataProvider>().setPage(Stage.PATIENT_HOME_SCREEN);
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
          TextField(
            controller: scanHn,
            focusNode: _focusNode,
            onSubmitted: (value) {
              provider.debugPrintV("CID (onSubmitted) = $value");
              provider.id = scanHn.text;
              sendvisitGatewayHn();
            },
          ),
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
                            AppLocalizations.of(context)!.home_promptIdOrScanHN,
                            style: TextStyle(
                              fontSize: width * 0.035,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Center(
                          child: Text(
                            texthead,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: width * 0.03,
                            ),
                          ),
                        ),
                        SizedBox(height: height * 0.005),
                        Center(
                          child: Container(
                            width: width * 0.7,
                            height: height * 0.07,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shownumpad = !shownumpad;
                                    });
                                  },
                                  child: const BoxID(),
                                ),
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
                                      width * provider.buttonSized_w,
                                      height * provider.buttonSized_h,
                                    ),
                                    onPressed: () {
                                      if (!provider.requirel_id_card) {
                                        sendvisitGateway();
                                      } else {
                                        provider.debugPrintV(
                                          "การตั้งค่าปังคับใช้บัตรเปิดอยู่",
                                        );
                                      }
                                    },
                                    child: Text(
                                      AppLocalizations.of(context)!.confirm,
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: width * 0.06,
                                      ),
                                    ),
                                  )
                                : SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width *
                                        0.05,
                                    height:
                                        MediaQuery.of(context).size.width *
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
                        ),
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
                            builder: (context) => const Setting(),
                          ),
                        );
                        // context.read<DataProvider>().setPage(
                        //   Stage.SETTING_SCREEN,
                        // );
                        provider.debugPrintV('Setting');
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        color: Colors.white,
                        child: const Icon(Icons.settings),
                        // Text(
                        //   "ตั้งค่า",
                        //   style: TextStyle(fontSize: width * 0.03),
                        // )
                      ),
                    ),
                  ),
                  const Text(""),
                  // GestureDetector(
                  //     onTap: () {
                  //       showDialog(
                  //           context: context,
                  //           builder: (BuildContext context) {
                  //             return Scaffold(
                  //               appBar: AppBar(),
                  //               body: Container(
                  //                 height: height * 0.8,
                  //                 child: ListView.builder(
                  //                     itemCount: context
                  //                         .read<DataProvider>()
                  //                         .debug
                  //                         .length,
                  //                     itemBuilder: (context, index) {
                  //                       return Padding(
                  //                         padding: const EdgeInsets.all(8.0),
                  //                         child: Text(
                  //                             "$index ${context.read<DataProvider>().debug[index]}"),
                  //                       );
                  //                     }),
                  //               ),
                  //             );
                  //           });
                  //     },
                  //     child: Container(
                  //         color: Colors.white, child: const Text("log"))),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
