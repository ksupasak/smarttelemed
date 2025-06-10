import 'dart:convert';
import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/views/ui/boxrecord.dart';
import 'package:smarttelemed/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/telemed/views/ui/popup.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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
  String warnTemp = '';
  String warnSpo2 = '';
  String warnbmi = '';
  String warnSys = '';
  String warnDia = '';
///////////////////////////////////////////////////////////////////////////
  bool statusConnectH_W = false;
  bool statusConnectSPO2 = false;
  bool statusConnectBP = false;
///////////////////////////////////////////////////////////////////////////

  final player = AudioPlayer();
  void playAudio() async {
    await player.play(UrlSource('assets/ScreenRecorderProject15.mp3'));
  }

  void initPorts() {
    DataProvider provider = context.read<DataProvider>();
    try {
      provider.debugPrintV('Available ports: ${availablePorts.length}');
    } catch (e) {
      provider.debugPrintV('Error retrieving ports: $e');
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
    DataProvider provider = context.read<DataProvider>();
    
    try {
      for (var name in SerialPort.availablePorts) {
        provider.debugPrintV('scan bp $name');
        final port = SerialPort(name);
        if (port.vendorId == 8137) {
          provider.debugPrintV("found BP");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
          }
          currentportBP = port;

          provider.debugPrintV("open BP");

          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          provider.debugPrintV("reader BP");
          setState(() {
            statusConnectBP = true;
          });
          reader.stream.listen((data) {
            provider.debugPrintV(' $data');

            if (data[0] == 50) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (true) {
                provider.debugPrintV('Buffer BP: $buffer');

                String txt = intArrayToString(buffer);
                provider.debugPrintV(txt);

                List<String> splitList = txt.split(";");

                int sys = int.parse(splitList[3].split(":")[1].split(" ")[0]);

                int dia = int.parse(splitList[5].split(":")[1].split(" ")[0]);

                int pr = int.parse(splitList[6].split(":")[1].split(" ")[0]);

                provider.debugPrintV('Sys: $sys, Dia:$dia pr: $pr');

                if (context.read<DataProvider>().datamin_max['minsys'] != '') {
                  if (sys <
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['minsys']
                          .toString())) {
                    warnSys =
                        S.of(context)!.health_sys_too_low; //"SYS ต่ำเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxsys'] != '') {
                  if (sys >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxsys']
                          .toString())) {
                    warnSys =
                        S.of(context)!.health_sys_too_high; //"SYS สูงเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }

                if (context.read<DataProvider>().datamin_max['mindia'] != '') {
                  if (dia <
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['mindia']
                          .toString())) {
                    warnDia =
                        S.of(context)!.health_dia_too_low; //"DIA ต่ำเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxdia'] != '') {
                  if (dia >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxdia']
                          .toString())) {
                    warnDia =
                        S.of(context)!.health_dia_too_high; //"DIA สูงเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }
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
      provider.debugPrintV("throwing new error");
      setState(() {
        statusConnectBP = false;
      });
    }
  }

//////////////////////////////////////////////////////////////////////////////
  void startSpo2() async {
    DataProvider provider = context.read<DataProvider>();

    try {
      for (var name in SerialPort.availablePorts) {
        provider.debugPrintV('scan spo2 $name');
        final port = SerialPort(name);
        if (port.vendorId == 1659) {
          provider.debugPrintV("found SPO2");
          int status = 0;
          if (!port.openReadWrite()) {
            provider.debugPrintV(SerialPort.lastError.toString());
            exit(-1);
          }
          currentportspo2 = port;

          provider.debugPrintV("open SPO2");

          SerialPortConfig config = port.config;
          config.baudRate = 38400;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          provider.debugPrintV("reader SPO2");
          setState(() {
            statusConnectSPO2 = true;
          });
          reader.stream.listen((data) {
            provider.debugPrintV('data SPO2: $data');
            if (data[0] == 42) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (buffer.length == 11) {
                provider.debugPrintV('Buffer SPO2: $buffer');
                if (buffer[2] == 83) {
                  int spo2 = buffer[5];
                  int pulse = buffer[6];
                  provider.debugPrintV('SpO2: $spo2, Pulse:$pulse');
                  if (spo2 > 0 && pulse > 0) {
                    if (context.read<DataProvider>().datamin_max['minspo2'] !=
                        '') {
                      if (spo2 <
                          double.parse(context
                              .read<DataProvider>()
                              .datamin_max['minspo2']
                              .toString())) {
                        warnSpo2 = S
                            .of(context)!
                            .health_spo2_too_low; //"Spo2 ต่ำเกินไป";
                        setState(() {
                          playAudio();
                        });
                      }
                    }
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
      provider.debugPrintV("throwing new error");
      setState(() {
        statusConnectSPO2 = false;
      });
    }
  }

/////////////////////////////////////////////////////////////////////////////

  void startH_W() async {
    DataProvider provider = context.read<DataProvider>();

    try {
      for (var name in SerialPort.availablePorts) {
        final port = SerialPort(name);
        provider.debugPrintV('scan W_H$name port:${port.vendorId}');
        if (port.vendorId == 6790) {
          provider.debugPrintV("found W_H");
          if (!port.openReadWrite()) {
            provider.debugPrintV(
                "SerialPort.lastError :${SerialPort.lastError.toString()}");
          }
          currentportHW = port;
          provider.debugPrintV("open W_H");
          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;
          List<int> buffer = [];
          final reader = SerialPortReader(port);
          provider.debugPrintV("reader W_H");
          setState(() {
            statusConnectH_W = true;
          });

          reader.stream.listen((data) {
            provider.debugPrintV("reader.stream.listen W_H:${data.toString()}");
            buffer.addAll(data);
            if (data[data.length - 1] == 10) {
              String txt = intArrayToString(buffer);
              provider.debugPrintV(txt);

              List<String> splitList = txt.split(" ");

              if (splitList.length == 1) {
                double temp = double.parse(splitList[0].split(":")[1]);

                context.read<DataProvider>().tempHealthrecord.text =
                    temp.toString();

                if (context.read<DataProvider>().datamin_max['mintemp'] != '') {
                  if (temp <
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['mintemp']
                          .toString())) {
                    warnTemp = S
                        .of(context)!
                        .health_temp_too_low; //อุณหภูมิ ต่ำเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxtemp'] != '') {
                  if (temp >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxtemp']
                          .toString())) {
                    warnTemp = S
                        .of(context)!
                        .health_temp_too_high; //"อุณหภูมิ สูงเกินไป";
                    setState(() {
                      playAudio();
                    });
                  }
                }
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

                  if (context.read<DataProvider>().datamin_max['minbmi'] !=
                      '') {
                    if (bmi <
                        double.parse(context
                            .read<DataProvider>()
                            .datamin_max['minbmi']
                            .toString())) {
                      warnbmi =
                          S.of(context)!.health_bmi_too_low; //"BMI ต่ำเกินไป";
                      setState(() {
                        playAudio();
                      });
                    }
                  }
                  if (context.read<DataProvider>().datamin_max['maxbmi'] !=
                      '') {
                    if (bmi >
                        double.parse(context
                            .read<DataProvider>()
                            .datamin_max['maxbmi']
                            .toString())) {
                      warnbmi =
                          S.of(context)!.health_bmi_too_high; //"BMI สูงเกินไป";
                      setState(() {
                        playAudio();
                      });
                    }
                  }
                }
              }

              buffer = [];
            } else {}
          });
        }
      }
    } on Exception catch (e) {
      provider.debugPrintV("throwing new error");
      provider.debugPrintV(e.toString());
      setState(() {
        statusConnectH_W = false;
      });
    }
  }

////////////////////////////////////////////////////////////////////////////

  void getClaimCode() async {
    DataProvider provider = context.read<DataProvider>();

    provider.debugPrintV("getClaimCode");
    provider.debugPrintV("pid : ${context.read<DataProvider>().id}");
    provider
        .debugPrintV("claimType : ${context.read<DataProvider>().claimType}");
    provider.debugPrintV("mobile : ${context.read<DataProvider>().phone}");
    provider.debugPrintV(
        "correlationId : ${context.read<DataProvider>().correlationId}");
    provider.debugPrintV("hn : ${context.read<DataProvider>().hn}");
    if (context.read<DataProvider>().claimType != "") {
      var url =
          Uri.parse('http://localhost:8189/api/nhso-service/confirm-save');

      var body = jsonEncode({
        "pid": context.read<DataProvider>().id,
        "claimType": context.read<DataProvider>().claimType,
        "mobile": context.read<DataProvider>().phone,
        "correlationId": context.read<DataProvider>().correlationId,
        "hn": context.read<DataProvider>().hn
      });

      var res = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      var resTojson = json.decode(res.body);
      provider.debugPrintV("statusCode getClaimCode ${res.statusCode}");
      if (res.statusCode == 200) {
        provider.debugPrintV("getClaimCode สำเร็จ ");
        provider.debugPrintV(resTojson.toString());
        context.read<DataProvider>().updateclaimCode(resTojson);
        sendDataHealthrecord();
      } else if (res.statusCode == 400) {
        var url = Uri.parse(
            'http://localhost:8189/api/nhso-service/latest-authen-code/${context.read<DataProvider>().id}');
        var res = await http.get(url);
        var resTojsonClaimCod = json.decode(res.body);
        context.read<DataProvider>().updateclaimCode(resTojsonClaimCod);
        sendDataHealthrecord();
      }
    } else {
      setState(() {
        buttonsend = !buttonsend;
      });
      sendDataHealthrecord();
      // showDialog(
      //     context: context,
      //     builder: (BuildContext context) {
      //       double height = MediaQuery.of(context).size.height;
      //       double width = MediaQuery.of(context).size.width;

      //       return Popup(
      //         texthead: 'ชำระค่ารักษาพยาบาลเอง',
      //         fontSize: width * 0.03,
      //         buttonbar: [
      //           ElevatedButton(
      //               style: stylebutter(
      //                   Colors.green,
      //                   width * provider.buttonSized_w,
      //                   height * provider.buttonSized_h),
      //               onPressed: () {
      //                 setState(() {
      //                   buttonsend = !buttonsend;
      //                 });
      //                 Navigator.pop(context);
      //                 sendDataHealthrecord();
      //               },
      //               child: Text(
      //                 S.of(context)!.confirm,
      //                 style: TextStyle(fontSize: width * 0.03),
      //               )),
      //         ],
      //       );
      //     });
    }
  }
////////////////////////////////////////////////////////////////////////////

  void sendDataHealthrecord() async {
    DataProvider provider = context.read<DataProvider>();

    provider.debugPrintV(
        "ส่งค่าHealthrecord ${context.read<DataProvider>().platfromURL}/add_visit");
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
      "height": context.read<DataProvider>().heightHealthrecord.text,
      "bmi": context.read<DataProvider>().bmiHealthrecord.text,
      "bp":
          "${context.read<DataProvider>().sysHealthrecord.text}/${context.read<DataProvider>().diaHealthrecord.text}",
      "claim_code": context.read<DataProvider>().claimCode.toString(),
    });

    if (res.statusCode == 200) {
      var resTojson = json.decode(res.body);
      provider.debugPrintV("ส่งค่าHealthrecord สำเร็จ");
      provider.debugPrintV(
          "resTojson sendDataHealthrecord ${resTojson.toString()}");
      sendHealthrecordGateway();
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  void sendHealthrecordGateway() async {
    DataProvider provider = context.read<DataProvider>();
    var body = jsonEncode({
      "vn": provider.vn,
      "hn": provider.hn,
      "cid": provider.id,
      "bmi": provider.bmiHealthrecord.text,
      "bpd": provider.diaHealthrecord.text,
      "bps": provider.sysHealthrecord.text,
      "fbs": "0",
      "rr": "0",
      "pulse": provider.pulseHealthrecord.text,
      "spo2": provider.spo2Healthrecord.text,
      "temp": provider.tempHealthrecord.text,
      "height": provider.heightHealthrecord.text,
      "weight": provider.weightHealthrecord.text 
    });
    try {
      provider.debugPrintV(
          "senvisitGateway :${provider.platfromURLGateway}/api/vitalsign");
      var url = Uri.parse('${provider.platfromURLGateway}/api/vitalsign');
      var response = await http.post(url,
          headers: {'Content-Type': 'application/json'}, body: body);
      provider.debugPrintV("response Gateway$response");
      var resTojsonGateway = json.decode(response.body);
      provider.debugPrintV("resTojsonGateway $resTojsonGateway");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Userinformation()));
    } catch (e) {
      provider.debugPrintV("error Gateway $e");
      Navigator.pushReplacement(context,
          MaterialPageRoute(builder: (context) => const Userinformation()));
    }
  }

  @override
  void initState() {
    context.read<DataProvider>().bmiHealthrecord = TextEditingController();
    context.read<DataProvider>().spo2Healthrecord = TextEditingController();
    context.read<DataProvider>().sysHealthrecord = TextEditingController();
    context.read<DataProvider>().heightHealthrecord = TextEditingController();
    context.read<DataProvider>().weightHealthrecord = TextEditingController();
    context.read<DataProvider>().diaHealthrecord = TextEditingController();
    context.read<DataProvider>().pulseHealthrecord = TextEditingController();
    context.read<DataProvider>().tempHealthrecord = TextEditingController();

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

  List<String> imggeCarouselSlider = [
    "assets/1117.png",
    "assets/ye990.png",
    "assets/unnamed.jpg",
  ];
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider provider = context.read<DataProvider>();
    TextStyle textStyle = TextStyle(fontSize: width * 0.03, color: Colors.red);
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          const Background(),
          Positioned(
            child: SizedBox(
                height: height,
                width: width,
                child: ListView(children: [
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
                  SizedBox(height: height * 0.01),
                  CarouselSlider.builder(
                    itemCount: 3,
                    options: CarouselOptions(
                        autoPlay: true,
                        enlargeCenterPage: true,
                        viewportFraction: 0.9,
                        aspectRatio: 2.0,
                        initialPage: 2,
                        autoPlayInterval: const Duration(seconds: 10)),
                    itemBuilder: (context, index, pageViewIndex) => Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(imggeCarouselSlider[index]),
                    ),
                  ),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        warnTemp != ""
                            ? Text(warnTemp, style: textStyle)
                            : const SizedBox(),
                        warnSys != ""
                            ? Text(warnSys, style: textStyle)
                            : const SizedBox(),
                        warnDia != ""
                            ? Text(warnDia, style: textStyle)
                            : const SizedBox(),
                        warnSpo2 != ""
                            ? Text(warnSpo2, style: textStyle)
                            : const SizedBox(),
                        warnbmi != ""
                            ? Text(warnbmi, style: textStyle)
                            : const SizedBox(),
                      ]),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        BoxRecord(
                            image: 'assets/jhv.png',
                            texthead: 'SYS',
                            keyvavlue: provider.sysHealthrecord),
                        BoxRecord(
                            image: 'assets/jhvkb.png',
                            texthead: 'DIA',
                            keyvavlue: provider.diaHealthrecord),
                        BoxRecord(
                            image: 'assets/jhbjk;.png',
                            texthead: 'PULSE',
                            keyvavlue: provider.pulseHealthrecord)
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
                            keyvavlue: provider.spo2Healthrecord),
                        BoxRecord(
                            image: 'assets/jhgh.png',
                            texthead: 'TEMP',
                            keyvavlue: provider.tempHealthrecord),
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
                            keyvavlue: provider.heightHealthrecord),
                        BoxRecord(
                            image: 'assets/srhnate.png',
                            texthead: 'WEIGHT',
                            keyvavlue: provider.weightHealthrecord),
                        BoxRecord(
                            image: 'assets/srhnate.png',
                            texthead: 'BMI',
                            keyvavlue: provider.bmiHealthrecord),
                      ],
                    ),
                  ),
                  SizedBox(height: height * 0.03),
                  Center(
                    child: buttonsend
                        ? ElevatedButton(
                            style: stylebutter(
                                Colors.green,
                                width * provider.buttonSized_w,
                                height * provider.buttonSized_h),
                            onPressed: () {
                              setState(() {
                                buttonsend = false;
                              });
                              getClaimCode();
                            },
                            child: Text(S.of(context)!.health_send,
                                style: TextStyle(
                                    fontSize: width * 0.06,
                                    color: Colors.white)))
                        : const SizedBox(child: CircularProgressIndicator()),
                  ),
                  SizedBox(height: height * 0.03),
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
                  //             S.of(context)!.leave,
                  //             style: TextStyle(
                  //                 color: Colors.red, fontSize: width * 0.03),
                  //           ),
                  //         ),
                  //       )),
                  // ),
                  Row(
                    children: [
                      ElevatedButton.icon(
                          onPressed: () {
                            showModalBottomSheet(
                              backgroundColor:
                                  const Color.fromARGB(0, 255, 255, 255),
                              isScrollControlled: true,
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(10))),
                              context: context,
                              builder: (context) => Container(
                                height: height * 0.3,
                                decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        topRight: Radius.circular(20))),
                                child: Column(children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        height: height * 0.01,
                                        width: width * 0.4,
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            color: Colors.grey)),
                                  ),
                                  SizedBox(
                                    width: width,
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/1117.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: statusConnectH_W
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/ye990.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: statusConnectBP
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Image.asset(
                                              "assets/unnamed.jpg",
                                              height: 50,
                                              width: 50,
                                            ),
                                            Container(
                                              height: 20,
                                              width: 20,
                                              decoration: BoxDecoration(
                                                  color: statusConnectSPO2
                                                      ? Colors.green
                                                      : Colors.red,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50)),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  )
                                ]),
                              ),
                            );
                          },
                          label: const Icon(Icons.settings)),
                    ],
                  )
                ])),
          ),
          // Positioned(
          //   bottom: 5,
          //   right: 5,
          //   child: GestureDetector(
          //       onTap: () {
          //         showDialog(
          //             context: context,
          //             builder: (BuildContext context) {
          //               return Scaffold(
          //                 appBar: AppBar(),
          //                 body: SizedBox(
          //                   height: height * 0.8,
          //                   child: ListView.builder(
          //                       itemCount:
          //                           context.read<DataProvider>().debug.length,
          //                       itemBuilder: (context, index) {
          //                         return Padding(
          //                           padding: const EdgeInsets.all(8.0),
          //                           child: Text(
          //                               "$index ${context.read<DataProvider>().debug[index]}"),
          //                         );
          //                       }),
          //                 ),
          //               );
          //             });
          //       },
          //       child:
          //           Container(color: Colors.white, child: const Text("log"))),
          // ),
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
                          builder: (context) => const Userinformation()));
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
                    S.of(context)!.health_backButton, // '< ย้อนกลับ'
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
