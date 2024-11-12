// ignore_for_file: non_constant_identifier_names, unused_local_variable, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

class SumHealthrecord extends StatefulWidget {
  const SumHealthrecord({super.key});

  @override
  State<SumHealthrecord> createState() => _SumHealthrecordState();
}

class _SumHealthrecordState extends State<SumHealthrecord> {
  List availablePorts = [];

  SerialPort? currentportBP;
  SerialPort? currentportspo2;
  SerialPort? currentportHW;
  bool buttonsend = true;
////////////////////////////////////////////////////////////////////////////////
  void initPorts() {
    try {
      debugPrint('Available ports: ${availablePorts.length}');
    } catch (e) {
      debugPrint('Error retrieving ports: $e');
      setState(() => availablePorts = []);
    }
  }

  String intArrayToString(List<int> intArray) {
    // Filter out values greater than 127
    List<int> filteredIntArray =
        intArray.where((value) => value <= 127).toList();

    return String.fromCharCodes(filteredIntArray);
  }

  void startBP() async {
    bool connect = false;

    try {
      for (var name in SerialPort.availablePorts) {
        debugPrint('scan $name');
        final port = SerialPort(name);
        if (port.vendorId == 8137) {
          debugPrint("found BP");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
          }
          currentportBP = port;

          debugPrint("open BP");

          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          debugPrint("reader BP");

          reader.stream.listen((data) {
            debugPrint('$data');

            if (data[0] == 50) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (true) {
                debugPrint('Buffer: $buffer');

                String txt = intArrayToString(buffer);
                debugPrint(txt);

                List<String> splitList = txt.split(";");

                int sys = int.parse(splitList[3].split(":")[1].split(" ")[0]);

                int dia = int.parse(splitList[5].split(":")[1].split(" ")[0]);

                int pr = int.parse(splitList[6].split(":")[1].split(" ")[0]);

                debugPrint('Sys: $sys, Dia:$dia pr: $pr');
                context.read<DataProvider>().sysHealthrecord.text =
                    sys.toString();
                context.read<DataProvider>().diaHealthrecord.text =
                    dia.toString();
                context.read<DataProvider>().pulseHealthrecord.text =
                    pr.toString();

                buffer = [];

                status = 0;
              }
            }
          });
        }
      }
    } on Exception catch (_) {
      print("throwing new error");
    }
  }

//////////////////////////////////////////////////////////////////////////////
  void startSpo2() async {
    bool connect = false;

    try {
      for (var name in SerialPort.availablePorts) {
        debugPrint('scan $name');
        final port = SerialPort(name);
        if (port.vendorId == 1659) {
          debugPrint("found SPO2");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
            exit(-1);
          }
          currentportspo2 = port;

          debugPrint("open SPO2");

          SerialPortConfig config = port.config;
          config.baudRate = 38400;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          debugPrint("reader SPO2");

          reader.stream.listen((data) {
            if (data[0] == 42) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (buffer.length == 11) {
                debugPrint('Buffer: $buffer');
                if (buffer[2] == 83) {
                  int spo2 = buffer[5];
                  int pulse = buffer[6];
                  debugPrint('SpO2: $spo2, Pulse:$pulse');
                  if (spo2 > 0 && pulse > 0) {
                    context.read<DataProvider>().spo2Healthrecord.text =
                        spo2.toString();
                  }
                }

                buffer = [];

                status = 0;
              }
            }
          });
        }
      }
    } on Exception catch (_) {
      print("throwing new error");
    }
  }

/////////////////////////////////////////////////////////////////////////////

  void startH_W() async {
    try {
      for (var name in SerialPort.availablePorts) {
        debugPrint('scan $name');
        final port = SerialPort(name);
        if (port.vendorId == 6790) {
          debugPrint("found W_H");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
          }
          currentportHW = port;
          debugPrint("open W_H");
          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;
          List<int> buffer = [];
          final reader = SerialPortReader(port);
          debugPrint("reader W_H");

          reader.stream.listen((data) {
            debugPrint(data.toString());
            buffer.addAll(data);
            if (data[data.length - 1] == 10) {
              String txt = intArrayToString(buffer);
              debugPrint(txt);

              List<String> splitList = txt.split(" ");

              if (splitList.length == 1) {
                double temp = double.parse(splitList[0].split(":")[1]);
                context.read<DataProvider>().tempHealthrecord.text =
                    temp.toString();
              } else {
                double weight = double.parse(splitList[0].split(":")[1]);
                context.read<DataProvider>().weightHealthrecord.text =
                    weight.toString();
                double height = double.parse(splitList[1].split(":")[1]);
                context.read<DataProvider>().heightHealthrecord.text =
                    height.toString();

                if (height > 0 && weight > 0) {
                  final double bmi = weight / ((height / 100) * (height / 100));
                  setState(() {
                    context.read<DataProvider>().bmiHealthrecord.text =
                        bmi.toStringAsFixed(2);
                  });
                }
              }

              buffer = [];
            } else {}
          });
        }
      }
    } on Exception catch (e) {
      print("throwing new error");
      print(e);
    }
  }

////////////////////////////////////////////////////////////////////////////

  void sendDataHealthrecord() async {
    debugPrint("ส่งค่าHealthrecord");
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/add_visit');
    var res = await http.post(url, body: {
      "public_id": context.read<DataProvider>().id,
      "care_unit_id": context.read<DataProvider>().care_unit_id,
      "temp": context.read<DataProvider>().tempHealthrecord.text,
      "weight": context.read<DataProvider>().weightHealthrecord.text,
      "bp_sys": context.read<DataProvider>().sysHealthrecord.text,
      "bp_dia": context.read<DataProvider>().diaHealthrecord.text,
      "pulse_rate": context.read<DataProvider>().pulseHealthrecord.text,
      "spo2": context.read<DataProvider>().spo2Healthrecord.text,
      "fbs": "",
      "height": context.read<DataProvider>().heightHealthrecord.text,
      "bmi": "",
      "bp":
          "${context.read<DataProvider>().sysHealthrecord.text}/${context.read<DataProvider>().diaHealthrecord.text}",
      "rr": "",
      "cc": "",
      "recep_public_id": "",
      "claim_code": context.read<DataProvider>().claimCode.toString(),
    });
    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {
      debugPrint("ส่งค่าHealthrecord สำเร็จ");
      debugPrint(resTojson.toString());
      getClaimCode();
    }
  }

  void getClaimCode() async {
    debugPrint("getClaimCode");
    debugPrint("pid : ${context.read<DataProvider>().id}");
    debugPrint("claimType : ${context.read<DataProvider>().claimType}");
    debugPrint("mobile : ${context.read<DataProvider>().tel.text}");
    debugPrint("correlationId : ${context.read<DataProvider>().correlationId}");
    debugPrint("hn : ${context.read<DataProvider>().hn.text}");

    var url = Uri.parse('http://localhost:8189/api/nhso-service/confirm-save');

    var body = jsonEncode({
      "pid": context.read<DataProvider>().id,
      "claimType": context.read<DataProvider>().claimType,
      "mobile": context.read<DataProvider>().tel.text,
      "correlationId": context.read<DataProvider>().correlationId,
      "hn": context.read<DataProvider>().hn.text
    });

    var res = await http.post(url,
        headers: {'Content-Type': 'application/json'}, body: body);
    var resTojson = json.decode(res.body);

    debugPrint("getClaimCode สำเร็จ ");
    debugPrint(resTojson.toString());

    if (res.statusCode == 200) {
      context.read<DataProvider>().updateclaimCode(resTojson);
      sendclaimCode();
    }
  }

  void sendclaimCode() async {
    debugPrint("sendClaimCode ");
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/set_claim_code');
    var res = await http.post(url, body: {
      "claim_code": context.read<DataProvider>().claimCode,
      "claim_type": context.read<DataProvider>().claimType,
      "claim_type_name": context.read<DataProvider>().claimTypeName,
      "public_id": context.read<DataProvider>().id,
    });
    var resTojson = json.decode(res.body);
    debugPrint(resTojson.toString());
    if (res.statusCode == 200) {
      debugPrint("sendClaimCode สำเร็จ ");
      setState(() {
        buttonsend = true;
      });
      Get.offNamed('user_information');
    }
  }

  @override
  void initState() {
    super.initState();
    startH_W();
    startBP();
    startSpo2();
  }

  @override
  void dispose() async {
    if (currentportBP != null) {
      await currentportBP?.close();
    }
    if (currentportHW != null) {
      await currentportHW?.close();
    }
    if (currentportspo2 != null) {
      await currentportspo2?.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height * 0.7,
        width: width,
        child: ListView(children: [
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/jhv.png',
                    texthead: 'SYS',
                    keyvavlue: context.read<DataProvider>().sysHealthrecord),
                BoxRecord(
                    image: 'assets/jhvkb.png',
                    texthead: 'DIA',
                    keyvavlue: context.read<DataProvider>().diaHealthrecord),
                BoxRecord(
                    image: 'assets/jhbjk;.png',
                    texthead: 'PULSE',
                    keyvavlue: context.read<DataProvider>().pulseHealthrecord)
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/kauo.png',
                    texthead: 'SPO2',
                    keyvavlue: context.read<DataProvider>().spo2Healthrecord),
                BoxRecord(
                    image: 'assets/jhgh.png',
                    texthead: 'TEMP',
                    keyvavlue: context.read<DataProvider>().tempHealthrecord),
              ],
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/shr.png',
                    texthead: 'HEIGHT',
                    keyvavlue: context.read<DataProvider>().heightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'WEIGHT',
                    keyvavlue: context.read<DataProvider>().weightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'BMI',
                    keyvavlue: context.read<DataProvider>().bmiHealthrecord),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                      onPressed: () {
                        Get.offNamed('user_information');
                        //   Get.toNamed('spo2');
                      },
                      child: Text(
                        "ย้อนกลับ",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        context.read<DataProvider>().sysHealthrecord.text =
                            '120';
                        context.read<DataProvider>().diaHealthrecord.text =
                            '80';
                        context.read<DataProvider>().pulseHealthrecord.text =
                            '89';
                        context.read<DataProvider>().spo2Healthrecord.text =
                            '99';
                        context.read<DataProvider>().heightHealthrecord.text =
                            '165';
                        context.read<DataProvider>().weightHealthrecord.text =
                            '50';
                        context.read<DataProvider>().tempHealthrecord.text =
                            '37.5';
                      },
                      child: Text(
                        "demo",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      )),
                  buttonsend
                      ? ElevatedButton(
                          onPressed: () {
                            setState(() {
                              buttonsend = !buttonsend;
                            });
                            sendDataHealthrecord();
                            dataProvider.updateviewhealthrecord("");
                          },
                          child: Text(
                            "ส่ง",
                            style: TextStyle(
                              fontSize: width * 0.03,
                            ),
                          ))
                      : const SizedBox(child: CircularProgressIndicator()),
                ]),
          )
        ]));
  }
}
