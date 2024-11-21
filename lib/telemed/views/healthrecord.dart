import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:smarttelemed/telemed/provider/provider.dart';

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
          setState(() {
            statusConnectBP = true;
          });
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

                if (context.read<DataProvider>().datamin_max['minsys'] != '') {
                  if (sys <
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['minsys']
                          .toString())) {
                    warnSys = "SYS ต่ำเกินไป";
                    setState(() {});
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxsys'] != '') {
                  if (sys >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxsys']
                          .toString())) {
                    warnSys = "SYS สูงเกินไป";
                    setState(() {});
                  }
                }

                if (context.read<DataProvider>().datamin_max['mindia'] != '') {
                  if (dia <
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['mindia']
                          .toString())) {
                    warnDia = "DIA ต่ำเกินไป";
                    setState(() {});
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxdia'] != '') {
                  if (dia >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxdia']
                          .toString())) {
                    warnDia = "DIA สูงเกินไป";
                    setState(() {});
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
      debugPrint("throwing new error");
      setState(() {
        statusConnectBP = false;
      });
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
            debugPrint(SerialPort.lastError.toString());
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
          setState(() {
            statusConnectSPO2 = true;
          });
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
                    if (context.read<DataProvider>().datamin_max['minspo2'] !=
                        '') {
                      if (spo2 <
                          double.parse(context
                              .read<DataProvider>()
                              .datamin_max['minspo2']
                              .toString())) {
                        warnSpo2 = "Spo2 ต่ำเกินไป";
                        setState(() {});
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
      debugPrint("throwing new error");
      setState(() {
        statusConnectSPO2 = false;
      });
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
            debugPrint(SerialPort.lastError.toString());
          }
          currentportHW = port;
          debugPrint("open W_H");
          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;
          List<int> buffer = [];
          final reader = SerialPortReader(port);
          debugPrint("reader W_H");
          setState(() {
            statusConnectH_W = true;
          });
          reader.stream.listen((data) {
            debugPrint("reader.stream.listen${data.toString()}");
            buffer.addAll(data);
            if (data[data.length - 1] == 10) {
              String txt = intArrayToString(buffer);
              debugPrint(txt);

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
                    warnTemp = "อุณหภูมิ ต่ำเกินไป";
                    setState(() {});
                  }
                }
                if (context.read<DataProvider>().datamin_max['maxtemp'] != '') {
                  if (temp >
                      double.parse(context
                          .read<DataProvider>()
                          .datamin_max['maxtemp']
                          .toString())) {
                    warnTemp = "อุณหภูมิ สูงเกินไป";
                    setState(() {});
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
                      warnbmi = "BMI ต่ำเกินไป";
                      setState(() {});
                    }
                  }
                  if (context.read<DataProvider>().datamin_max['maxbmi'] !=
                      '') {
                    if (bmi >
                        double.parse(context
                            .read<DataProvider>()
                            .datamin_max['maxbmi']
                            .toString())) {
                      warnbmi = "BMI สูงเกินไป";
                      setState(() {});
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
      debugPrint("throwing new error");
      debugPrint(e.toString());
      setState(() {
        statusConnectH_W = false;
      });
    }
  }

////////////////////////////////////////////////////////////////////////////

  void getClaimCode() async {
    debugPrint("getClaimCode");
    debugPrint("pid : ${context.read<DataProvider>().id}");
    debugPrint("claimType : ${context.read<DataProvider>().claimType}");
    debugPrint("mobile : ${context.read<DataProvider>().tel.text}");
    debugPrint("correlationId : ${context.read<DataProvider>().correlationId}");
    debugPrint("hn : ${context.read<DataProvider>().hn.text}");
    if (context.read<DataProvider>().claimType != "") {
      var url =
          Uri.parse('http://localhost:8189/api/nhso-service/confirm-save');

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
      debugPrint("statusCode getClaimCode ${res.statusCode}");
      if (res.statusCode == 200) {
        debugPrint("getClaimCode สำเร็จ ");
        debugPrint(resTojson.toString());
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
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return Popup(
              texthead: 'ชำระค่ารักษาพยาบาลเอง',
              buttonbar: [
                GestureDetector(
                    onTap: () {
                      setState(() {
                        buttonsend = !buttonsend;
                      });
                      Navigator.pop(context);
                      sendDataHealthrecord();
                    },
                    child: BoxWidetdew(
                        color: const Color.fromARGB(255, 106, 173, 115),
                        height: 0.05,
                        width: 0.2,
                        text: 'ตกลง',
                        textcolor: Colors.white)),
                GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: BoxWidetdew(
                        color: const Color.fromARGB(255, 173, 106, 106),
                        height: 0.05,
                        width: 0.2,
                        text: 'ยกเลิก',
                        textcolor: Colors.white))
              ],
            );
          });
    }
  }
////////////////////////////////////////////////////////////////////////////

  void sendDataHealthrecord() async {
    debugPrint("ส่งค่าHealthrecord${context.read<DataProvider>().platfromURL}");
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
    debugPrint("ส่งค่าHealthrecordสำเร็จ");
    debugPrint(res.statusCode.toString());

    if (res.statusCode == 200) {
      var resTojson = json.decode(res.body);
      debugPrint("ส่งค่าHealthrecord สำเร็จ");
      debugPrint(resTojson.toString());
      sendHealthrecordGateway();
    }
  }

  ////////////////////////////////////////////////////////////////////////////
  void sendHealthrecordGateway() async {
    // var url = Uri.parse('');
    // Map<String, String> data ={};
    //       var res = await http.post(url,body: data);
    //        var resTojsonClaimCod = json.decode(res.body);
    Get.offNamed('user_information');
  }

  // void sendclaimCode() async {
  //   debugPrint("sendClaimCode ");
  //   var url =
  //       Uri.parse('https://emr-life.com/clinic_master/clinic/Api/set_claim_code');
  //   var res = await http.post(url, body: {
  //     "claim_code": context.read<DataProvider>().claimCode,
  //     "claim_type": context.read<DataProvider>().claimType,
  //     "claim_type_name": context.read<DataProvider>().claimTypeName,
  //     "public_id": context.read<DataProvider>().id,
  //   });
  //   var resTojson = json.decode(res.body);
  //   debugPrint(resTojson.toString());
  //   if (res.statusCode == 200) {
  //     debugPrint("sendClaimCode สำเร็จ ");
  //     setState(() {
  //       buttonsend = true;
  //     });
  //     Get.offNamed('user_information');
  //   }
  // }
  void getmin_max() async {
    List<RecordSnapshot<int, Map<String, Object?>>> data = await getMinMax();
    debugPrint(data.toString());
    if (data != []) {
      for (RecordSnapshot<int, Map<String, Object?>> record in data!) {
        context.read<DataProvider>().datamin_max['minsys'] =
            record["minsys"].toString();
        context.read<DataProvider>().datamin_max['maxsys'] =
            record["maxsys"].toString();
        context.read<DataProvider>().datamin_max['minspo2'] =
            record["minspo2"].toString();
        context.read<DataProvider>().datamin_max['maxspo2'] =
            record["maxspo2"].toString();
        context.read<DataProvider>().datamin_max['mindia'] =
            record["mindia"].toString();
        context.read<DataProvider>().datamin_max['maxdia'] =
            record["maxdia"].toString();

        context.read<DataProvider>().datamin_max['mintemp'] =
            record["mintemp"].toString();
        context.read<DataProvider>().datamin_max['maxtemp'] =
            record["maxtemp"].toString();
        context.read<DataProvider>().datamin_max['minbmi'] =
            record["minbmi"].toString();
        context.read<DataProvider>().datamin_max['maxbmi'] =
            record["maxbmi"].toString();
      }
    }
    setState(() {});
  }

  @override
  void initState() {
    context.read<DataProvider>().bmiHealthrecord = TextEditingController();
    super.initState();
    getmin_max();
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
    DataProvider dataProvider = context.read<DataProvider>();
    TextStyle textStyle = TextStyle(fontSize: width * 0.03, color: Colors.red);
    return SizedBox(
        height: height * 0.78,
        width: width,
        child: ListView(children: [
          // Text(
          //     "${context.read<DataProvider>().datamin_max['minspo2']}/${context.read<DataProvider>().datamin_max['maxspo2']}"),
          // Text(
          //     "${context.read<DataProvider>().datamin_max['minsys']}/${context.read<DataProvider>().datamin_max['maxsys']}"),
          // Text(
          //     "${context.read<DataProvider>().datamin_max['mindia']}/${context.read<DataProvider>().datamin_max['maxdia']}"),
          // Text(
          //     "${context.read<DataProvider>().datamin_max['mintemp']}/${context.read<DataProvider>().datamin_max['maxtemp']}"),
          // Text(
          //     "${context.read<DataProvider>().datamin_max['minbmi']}/${context.read<DataProvider>().datamin_max['maxbmi']}"),
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
          Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            warnTemp != ""
                ? Text(warnTemp, style: textStyle)
                : const SizedBox(),
            warnSys != "" ? Text(warnSys, style: textStyle) : const SizedBox(),
            warnDia != "" ? Text(warnDia, style: textStyle) : const SizedBox(),
            warnSpo2 != ""
                ? Text(warnSpo2, style: textStyle)
                : const SizedBox(),
            warnbmi != "" ? Text(warnbmi, style: textStyle) : const SizedBox(),
          ]),
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
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                  ),
                  onPressed: () {
                    Get.offNamed('user_information');
                    //   Get.toNamed('spo2');
                  },
                  child: Text(
                    "กลับ",
                    style:
                        TextStyle(fontSize: width * 0.03, color: Colors.white),
                  )),
              SizedBox(width: width * 0.05),
              buttonsend
                  ? ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          buttonsend = !buttonsend;
                        });
                        getClaimCode();

                        dataProvider.updateviewhealthrecord("");
                      },
                      child: Text(
                        "ส่ง",
                        style: TextStyle(
                            fontSize: width * 0.03, color: Colors.white),
                      ))
                  : const SizedBox(child: CircularProgressIndicator()),
            ]),
          ),

          Row(
            children: [
              ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
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
                                    borderRadius: BorderRadius.circular(50),
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
                                              BorderRadius.circular(50)),
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
                                              BorderRadius.circular(50)),
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
                                              BorderRadius.circular(50)),
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
        ]));
  }
}
