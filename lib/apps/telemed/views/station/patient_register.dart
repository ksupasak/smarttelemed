// ignore_for_file: non_constant_identifier_names, use_build_context_synchronously, sort_child_properties_last

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/apps/telemed/core/services/background.dart/background.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';

class PatientRegister extends StatefulWidget {
  const PatientRegister({super.key});

  @override
  State<PatientRegister> createState() => _PatientRegisterState();
}

class _PatientRegisterState extends State<PatientRegister> {
  bool status = false;
  String text = '';
  bool shiftEnabled = false;
  bool isNumericMode = false;
  bool keyboardHN = false;
  bool keyboardPhone = false;
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
      'http://localhost:8189/api/smartcard/read?readImageFlag=true',
    );
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
      var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/add_patient',
      );
      var res = await http.post(
        url,
        body: {
          'care_unit_id': context.read<DataProvider>().care_unit_id,
          'public_id': id.text,
          'prefix_name': prefix_name.text,
          'first_name': first_name.text,
          'last_name': last_name.text,
          'tle': phone.text,
          'hn': hn.text,
        },
      );
      var resTojson = json.decode(res.body);
      if (res.statusCode == 200) {
        provider.debugPrintV("สมัคข้อมูลในESMสำเร็จ");
        provider.debugPrintV("StatusresTojson :${resTojson["message"]}");
        if (resTojson["message"] == "success") {
          provider.debugPrintV("เพิ่มข้อมูลลงprovider ");
          provider.hn = hn.text;
          provider.phone = phone.text;
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
        } else {
          provider.debugPrintV(
            "สมัครข้อมูลในESMใม่สำเร็จ error:${res.statusCode}",
          );
          setState(() {
            status = false;
          });
        }
      }
    } catch (e) {
      provider.debugPrintV("สมัครข้อมูลในESMใม่สำเร็จ error:$e");
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
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      child: child != null
          ? Text(
              child,
              style: const TextStyle(color: Color.fromARGB(255, 0, 28, 155)),
            )
          : const Text('-'),
    );
  }

  Widget Boxheab({required String child}) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Container(
      width: width * 0.4,
      height: height * 0.027,
      decoration: BoxDecoration(
        border: Border.all(color: const Color.fromARGB(255, 0, 0, 0)),
      ),
      child: Text(
        child,
        style: const TextStyle(color: Color.fromARGB(255, 3, 58, 58)),
      ),
    );
  }

  Widget textdatauser({TextEditingController? child, String? namekeyboard}) {
    double width = MediaQuery.of(context).size.width;
    //double height = MediaQuery.of(context).size.height;
    TextStyle style2 = TextStyle(
      fontSize: width * 0.035,
      color: const Color(0xff003D5C),
    );
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
                setState(() {
                  if (namekeyboard == "hn") {
                    keyboardHN = true;
                    keyboardPhone = false;
                    setState(() {});
                  }
                  if (namekeyboard == "phone") {
                    keyboardPhone = true;
                    keyboardHN = false;
                    setState(() {});
                  }
                });
              },
              onEditingComplete: () {
                //  FocusScope.of(context).unfocus();
              },
              controller: child,
              style: style2,
            ),
          ),
          decoration: boxDecorate,
        ),
      ],
    );
  }

  Decoration boxDecorate = BoxDecoration(
    boxShadow: const [
      BoxShadow(
        offset: Offset(0, 2.5),
        blurRadius: 3,
        color: Color(0xff31D6AA),
      ),
    ],
    borderRadius: BorderRadius.circular(10),
    color: Colors.white,
  );
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      text = text + ((shiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (text.length == 0) return;
          text = text.substring(0, text.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          setState(() {
            keyboardHN = false;
            keyboardPhone = false;
          });
          break;
        case VirtualKeyboardKeyAction.Space:
          text = text + (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;

        default:
      }
    }
    // Update the screen
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyle textStyle = TextStyle(
      fontSize: width * 0.06,
      color: const Color(0xff31D6AA),
    );
    TextStyle style2 = TextStyle(
      fontSize: width * 0.04,
      color: const Color(0xff003D5C),
    );
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          keyboardHN = false;
          keyboardPhone = false;
          setState(() {});
        },
        child: Stack(
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
                            Text(
                              AppLocalizations.of(context)!.regis_register,
                              style: textStyle,
                            ),
                            SizedBox(
                              width: width * 0.8,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${AppLocalizations.of(context)!.regis_prefix} :${prefix_name.text}',
                                    style: style2,
                                  ),
                                  // textdatauser(child: prefix_name),
                                  Text(
                                    '${AppLocalizations.of(context)!.regis_firstname} :${first_name.text}',
                                    style: style2,
                                  ),
                                  //  textdatauser(child: first_name),
                                  Text(
                                    '${AppLocalizations.of(context)!.regis_lastname} :${last_name.text}',
                                    style: style2,
                                  ),
                                  //   textdatauser(child: last_name),
                                  Text(
                                    '${AppLocalizations.of(context)!.regis_birthday} :${birthdate.text}',
                                    style: style2,
                                  ),
                                  //   textdatauser(child: birthdate),
                                  Text(
                                    '${AppLocalizations.of(context)!.regis_IdCard} :${id.text}',
                                    style: style2,
                                  ),
                                  //   textdatauser(child: id),
                                  Text(
                                    AppLocalizations.of(context)!.regis_phone,
                                    style: style2,
                                  ),
                                  textdatauser(
                                    child: phone,
                                    namekeyboard: "hn",
                                  ),
                                  phone.text == ""
                                      ? Center(
                                          child: Text(
                                            // เลขเกิน 10 หลัก
                                            phone.text.length > 10
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.regis_tenDigitNumberPrompt
                                                : AppLocalizations.of(
                                                    context,
                                                  )!.regis_enterphone,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            // เลขเกิน 10 หลัก
                                            phone.text.length > 10
                                                ? AppLocalizations.of(
                                                    context,
                                                  )!.regis_tenDigitNumberPrompt
                                                : "",
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                  Text(
                                    AppLocalizations.of(context)!.regis_codeHN,
                                    style: style2,
                                  ),
                                  textdatauser(
                                    child: hn,
                                    namekeyboard: "phone",
                                  ),
                                  hn.text == ""
                                      ? Center(
                                          child: Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.regis_enterHN,
                                            style: const TextStyle(
                                              color: Colors.red,
                                            ),
                                          ),
                                        )
                                      : const SizedBox(),
                                ],
                              ),
                            ),
                            SizedBox(height: height * 0.03),
                            keyboardHN
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.black,
                                      child: Column(
                                        children: [
                                          VirtualKeyboard(
                                            height: 300,
                                            width: 500,
                                            textColor: Colors.white,
                                            textController: phone,
                                            defaultLayouts: const [
                                              VirtualKeyboardDefaultLayouts
                                                  .English,
                                            ],
                                            type: VirtualKeyboardType.Numeric,
                                            postKeyPress: _onKeyPress,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            keyboardPhone
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      color: Colors.black,
                                      child: Column(
                                        children: [
                                          VirtualKeyboard(
                                            height: 300,
                                            width: 500,
                                            textColor: Colors.white,
                                            textController: hn,
                                            defaultLayouts: const [
                                              VirtualKeyboardDefaultLayouts
                                                  .English,
                                            ],
                                            type: isNumericMode
                                                ? VirtualKeyboardType.Numeric
                                                : VirtualKeyboardType
                                                      .Alphanumeric,
                                            postKeyPress: _onKeyPress,
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : const SizedBox(),
                            !status
                                ? GestureDetector(
                                    onTap: () {
                                      if (hn.text != "" && phone.text != "") {
                                        regter();
                                      }
                                    },
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
                                            blurRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: Row(
                                        children: [
                                          Image.asset('assets/rsjyrsk.png'),
                                          Text(
                                            AppLocalizations.of(
                                              context,
                                            )!.regis_register,
                                            style: TextStyle(
                                              fontSize: width * 0.04,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ],
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
      ),
      bottomNavigationBar: SizedBox(
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  // Navigator.pushReplacement(
                  //   context,
                  //   MaterialPageRoute(
                  //     builder: (context) => const HomeTelemed(),
                  //   ),
                  // );
                  context.read<DataProvider>().setPage(Stage.HOME_SCREEN);
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
                      AppLocalizations.of(context)!.regis_backButton,
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
}
