import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart'; 
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';

import 'package:http/http.dart' as http; 
import 'package:smarttelemed/myapp/action/playsound.dart';
import 'package:smarttelemed/myapp/setting/device/requestLocationPermission.dart';
import 'package:smarttelemed/myapp/splash_screen/splash_screen.dart';
import 'package:smarttelemed/myapp/provider/provider.dart';
import 'package:smarttelemed/myapp/setting/local.dart'; 

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
  TextEditingController app = TextEditingController();
  late List<RecordSnapshot<int, Map<String, Object?>>> dataHospital;
  var resTojson;
  var resTojson2;
  int? numindex;
  bool status_safe = false;
  void test() {
    platfromURL.text = 'https://emr-life.com/clinic_master/clinic/Api';
  }

  void sync() async {
    try {
      var url = Uri.parse('${platfromURL.text}/list_care_unit');
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
                        fontFamily: context.read<DataProvider>().family,
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
                        fontFamily: context.read<DataProvider>().family,
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
                'platformURL ผิด',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void safe() async {
    context.read<DataProvider>().name_hospital = name_hospital.text;
    context.read<DataProvider>().platfromURL = platfromURL.text;
    context.read<DataProvider>().care_unit_id = care_unit_id.text;
    context.read<DataProvider>().password = passwordsetting.text;
    context.read<DataProvider>().care_unit = care_unit.text;
    context.read<DataProvider>().app = app.text;

    setState(() {
      status_safe = true;
      addDataInfoToDatabase(context.read<DataProvider>());
      Future.delayed(const Duration(seconds: 2), () {
        setState(() {
          status_safe = false;
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) => const Splash_Screen()));
        });
      });
    });
  }

  Future<void> printDatabase() async {
    var knownDevice;

    dataHospital = await getAllData();
    for (RecordSnapshot<int, Map<String, Object?>> record in dataHospital) {
      setState(() {
        app.text = record['myapp'].toString();
        name_hospital.text = record['name_hospital'].toString();
        platfromURL.text = record['platfromURL'].toString();
        care_unit_id.text = record['care_unit_id'].toString();
        care_unit.text = record['care_unit'].toString();
        passwordsetting.text = record['passwordsetting'].toString();
      });

      print(name_hospital.text);
      print(platfromURL.text);
      print(care_unit.text);
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
                    fontFamily: context.read<DataProvider>().family,
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
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  String maskString(
      String original, int prefixLength, int suffixLength, String maskChar) {
    if (original.length <= prefixLength + suffixLength) {
      return original;
    }

    String prefix = original.substring(0, prefixLength);
    String suffix = original.substring(original.length - suffixLength);
    String masked = prefix +
        maskChar * (original.length - prefixLength - suffixLength) +
        suffix;

    return masked;
  }

  @override
  void initState() {
    printDatabase();
    requestLocationPermission();
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
            backgroundColor: Color.fromARGB(255, 245, 245, 245),
            appBar: AppBar(
              backgroundColor: Colors.white,
              actions: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      keypad_sound();
                      test();
                    },
                    child: Icon(
                      Icons.download,
                      color: Colors.black,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: GestureDetector(
                    onTap: () {
                      keypad_sound();
                      safe();
                    },
                    child: status_safe == false
                        ? Icon(
                            Icons.save,
                            color: Colors.black,
                          )
                        : CircularProgressIndicator(),
                  ),
                ),
              ],
            ),
            body: Stack(children: [
              Positioned(
                  child: ListView(children: [
                Container(
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(children: [
                          Text('Set Up', style: TextStyle(color: Colors.grey))
                        ]),
                      ),
                      Container(
                        width: _width * 0.98,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  color: Color.fromARGB(255, 225, 225, 225),
                                  offset: Offset(0, 1))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              BoxTextFieldSetting(
                                  keyvavlue: platfromURL,
                                  texthead: 'PlatfromURL'),
                              BoxTextFieldSetting(
                                  keyvavlue: id_hospital,
                                  texthead: 'Id_Hospital'),
                              Container(
                                  child: Center(
                                      child: GestureDetector(
                                          onTap: () {
                                            sync();
                                          },
                                          child: Container(
                                            child: Icon(Icons.sync_alt),
                                          )))),
                              Container(
                                height: resTojson2 != null
                                    ? resTojson2['data'].length != 0
                                        ? _height * 0.3
                                        : 0
                                    : 0,
                                child: resTojson2 != null
                                    ? resTojson2['data'].length != 0
                                        ? ListView.builder(
                                            itemCount:
                                                resTojson2['data'].length,
                                            itemBuilder: (context, index) {
                                              return GestureDetector(
                                                onTap: () {
                                                  keypad_sound();
                                                  setState(() {
                                                    numindex = index;
                                                    care_unit.text =
                                                        resTojson2['data']
                                                            [index]['name'];
                                                    care_unit_id.text =
                                                        resTojson2['data']
                                                            [index]['id'];
                                                    name_hospital.text =
                                                        resTojson2[
                                                            'customer_name'];
                                                    app.text =
                                                        resTojson2['data']
                                                            [index]['type'];
                                                    print(app.text);
                                                  });
                                                },
                                                child: Center(
                                                    child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(2.0),
                                                  child: Container(
                                                      decoration: BoxDecoration(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(5),
                                                          color: numindex ==
                                                                  index
                                                              ? Color.fromRGBO(
                                                                  226,
                                                                  255,
                                                                  227,
                                                                  1)
                                                              : Colors.white,
                                                          boxShadow: [
                                                            BoxShadow(
                                                                blurRadius: 1,
                                                                offset: Offset(
                                                                    0, 1),
                                                                color: Colors
                                                                    .green)
                                                          ]),
                                                      width: _width * 0.7,
                                                      height: _height * 0.05,
                                                      child: Center(
                                                        child: Text(
                                                            resTojson2['data']
                                                                [index]['name'],
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .green)),
                                                      )),
                                                )),
                                              );
                                            })
                                        : Container()
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Text('Password',
                                style: TextStyle(color: Colors.grey))
                          ])),
                      Container(
                        width: _width * 0.98,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  color: Color.fromARGB(255, 225, 225, 225),
                                  offset: Offset(0, 1))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            BoxTextFieldSetting(
                                lengthlimitingtextinputformatter: 4,
                                keyvavlue: passwordsetting,
                                texthead: 'Password Setting',
                                textinputtype: TextInputType.number),
                          ]),
                        ),
                      ),
                      Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(children: [
                            Text('About', style: TextStyle(color: Colors.grey))
                          ])),
                      Container(
                        width: _width * 0.98,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 1,
                                  color: Color.fromARGB(255, 225, 225, 225),
                                  offset: Offset(0, 1))
                            ]),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(children: [
                            BoxText(keyvavlue: app.text, texthead: 'ประเภทApp'),
                            BoxText(
                                keyvavlue: maskString(
                                    context.read<DataProvider>().appId,
                                    3,
                                    3,
                                    "*"),
                                texthead: 'App Id'),
                            BoxText(
                                keyvavlue: name_hospital.text,
                                texthead: 'Name Hospital'),
                            BoxText(
                                keyvavlue: care_unit.text,
                                texthead: 'Care Unit'),
                            BoxText(
                                keyvavlue: care_unit_id.text,
                                texthead: 'Care Unit id'),
                          ]),
                        ),
                      ),
                    ]))
              ]))
            ])));
  }
}

class BoxTextFieldSetting extends StatefulWidget {
  BoxTextFieldSetting(
      {super.key,
      this.keyvavlue,
      this.texthead,
      this.textinputtype,
      this.lengthlimitingtextinputformatter});
  var keyvavlue;
  String? texthead;
  TextInputType? textinputtype;
  int? lengthlimitingtextinputformatter;
  @override
  State<BoxTextFieldSetting> createState() => _BoxTextFieldSettingState();
}

class _BoxTextFieldSettingState extends State<BoxTextFieldSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.texthead == null
                  ? Text('')
                  : Text(widget.texthead.toString(), style: style1),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow()],
                    borderRadius: BorderRadius.circular(5)),
                width: _width * 0.9,
                child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: widget.textinputtype,
                    controller: widget.keyvavlue,
                    inputFormatters:
                        widget.lengthlimitingtextinputformatter == null
                            ? []
                            : [
                                LengthLimitingTextInputFormatter(
                                    widget.lengthlimitingtextinputformatter),
                              ],
                    style: style2),
              ),
            ]),
      ),
    );
  }
}

class BoxText extends StatefulWidget {
  BoxText({
    super.key,
    this.keyvavlue,
    this.texthead,
    this.textinputtype,
  });
  String? keyvavlue;
  String? texthead;
  TextInputType? textinputtype;

  @override
  State<BoxText> createState() => _BoxTextState();
}

class _BoxTextState extends State<BoxText> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.texthead == null
                  ? Text('')
                  : Text(widget.texthead.toString(), style: style1),
              Container(
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(5)),
                width: _width * 0.9,
                child: Text(
                  '${widget.keyvavlue}',
                  style: style2,
                ),
              ),
              SizedBox(height: 10),
              Container(
                  color: Color.fromARGB(100, 158, 158, 158),
                  height: 1,
                  width: _width * 0.9),
            ]),
      ),
    );
  }
}
