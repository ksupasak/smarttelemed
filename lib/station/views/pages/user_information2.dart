// ignore_for_file: prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously, camel_case_types

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/provider/provider_function.dart';
 
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:http/http.dart' as http;


import 'package:flutter/services.dart' show rootBundle;
//import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class UserInformation extends StatefulWidget {
  const UserInformation({super.key});

  @override
  State<UserInformation> createState() => _UserInformationState();
}

class _UserInformationState extends State<UserInformation> {
 

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          Positioned(
              child: ListView(
            children: [
              BoxDecorate(
                  color: const Color.fromARGB(255, 43, 179, 161),
                  child: InformationCard(
                      dataidcard: context.read<DataProvider>().dataidcard)),
            ],
          ))
        ],
      ),
    ));
  }
}

class UserInformation2 extends StatefulWidget {
  const UserInformation2({super.key});

  @override
  State<UserInformation2> createState() => _UserInformation2State();
}

class _UserInformation2State extends State<UserInformation2> {
  Timer? _timer;
  var resTojson4;
  var resTojson3;
  var resTojson2;
  var resTojson;
  String height = '-';
  String weight = '-';
  String temp = '-';
  String sys = '-';
  String dia = '-';
  String spo2 = '-';
  String status = '';
  // ESMPrinter? printer;
  bool status2 = false;
  bool ontap = false;
  String doctor_note = '--';
  String dx = '--';
// -------

  // < karn  start >
  FocusNode _focusNode = FocusNode();   
  Printer? selectedPrinter; // Stores the selected printer
  late pw.Font thaiFont;
  // < karn  end >

  var resToJsonCheckQuick;
  Timer? timerCheckQuick;
  Future<void> checkQuick() async {
    timerCheckQuick = Timer.periodic(const Duration(seconds: 4), (timer) async {
      var url =
          Uri.parse('${context.read<DataProvider>().platfromURL}/check_quick');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      resToJsonCheckQuick = json.decode(res.body);
      setState(() {});
      if (res.statusCode == 200) {
        //debugPrint("Status ${resToJsonCheckQuick}");
        if (resToJsonCheckQuick["health_records"].length != 0) {
          context.read<DataProvider>().heightHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["height"];
          context.read<DataProvider>().weightHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["weight"];
          context.read<DataProvider>().tempHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["temp"];
          context.read<DataProvider>().sysHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["bp_sys"];
          context.read<DataProvider>().diaHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["bp_dia"];
          context.read<DataProvider>().pulseHealthrecord.text =
              resToJsonCheckQuick["health_records"][0]["pulse_rate"];
          context.read<DataProvider>().spo2Healthrecord.text =
              resToJsonCheckQuick["health_records"][0]["spo2"];

          //   debugPrint(context.read<DataProvider>().heightHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().weightHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().tempHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().sysHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().diaHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().pulseHealthrecord.text);
          //   debugPrint(context.read<DataProvider>().spo2Healthrecord.text);
        }
      }
      if (resToJsonCheckQuick["message"] == "processing") {
        // timerCheckQuick?.cancel();
      }
      if (resToJsonCheckQuick["message"] == "completed") {
        debugPrint("ตรวจเสร็จเเล้ว message completed");
        timerCheckQuick?.cancel();
        finished();
        exam();
      }
      if (resToJsonCheckQuick["message"] == "finished") {
        debugPrint("ตรวจเสร็จเเล้ว message finished");
        timerCheckQuick?.cancel();
        exam();
      }
    });
  }

  Future<void> finished() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/finish_appoint');
    await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
  }

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);

      if (resTojson != null) {
        if (resTojson['queue_number'] != '') {
          lop_queue();
        } else {
          setState(() {
            status2 = true;
          });
        }
      }
      check_status();
    });
    if (resTojson['health_records'].length != 0) {
      height = resTojson['health_records'][0]['height'].toString();
      weight = resTojson['health_records'][0]['weight'].toString();
      temp = resTojson['health_records'][0]['temp'].toString();
      sys = resTojson['health_records'][0]['bp_sys'].toString();
      dia = resTojson['health_records'][0]['bp_dia'].toString();
      spo2 = resTojson['health_records'][0]['spo2'].toString();
    }
  }

  void lop_queue() {
    _timer = Timer.periodic(const Duration(seconds: 2), (timer) {
      setState(() {
        get_queue();
      });
    });
  }

  Future<void> get_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id, //1
    });
    setState(() {
      resTojson2 = json.decode(res.body);

      if (resTojson2 != null) {
        setState(() {});
        if (resTojson['queue_number'].toString() ==
                resTojson2['queue_number'].toString() &&
            resTojson['queue_number'] != '') {
          setState(() {
            debugPrint('ถึงคิว');
            _timer?.cancel();

            // Navigator.push(context,
            //     MaterialPageRoute(builder: (context) => const PrePareVideo()));
            status2 = true;
          });
        } else {
          debugPrint('ยังไม่ถึงคิว');
          debugPrint(
              "คิวผู้ใช้        ${resTojson['queue_number'].toString()}");
          debugPrint(
              "คิวที่กำลังเรียก  ${resTojson2['queue_number'].toString()}");
        }
      } else {
        setState(() {
          status2 = true;
        });
      }
    });
  }

  Future<void> check_status() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_video_status');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });

    setState(() {
      resTojson4 = json.decode(res.body);
      if (resTojson4 != null) {
        if (resTojson4['message'] == 'end') {
          setState(() {
            status = 'end';
            stop();
          });
        } else if (resTojson4['message'] == 'finished') {
          setState(() {
            status = 'finished';
            stop();
          });
          debugPrint('รายาการวันนี้เสร็จสิ้นเเล้ว');
        } else if (resTojson4['message'] == 'completed') {
          debugPrint('คุยเสร็จเเล้ว');
          setState(() {
            status = 'completed';
            stop();
          });
        } else if (resTojson4['message'] == 'processing') {
          setState(() {
            status = 'processing';
          });
          debugPrint('ถึงคิวเเล้ว');
        } else if (resTojson4['message'] == 'waiting') {
          debugPrint('ยังไม่ถึงคิว');
        } else if (resTojson4['message'] == 'no queue') {
          debugPrint('มีตรวจ/ยังไม่มีคิว');
        } else if (resTojson4['message'] == 'not found today appointment') {
          debugPrint('วันนี้ไม่มีรายการ');
        } else {
          debugPrint('resTojson4= ${resTojson4['message']}');
        }
      } else {
        debugPrint('resTojson = null');
      }
    });
  }

  void stop() {
    setState(() {
      _timer?.cancel();
    });
  }

  Future<void> q() async {
    if (resTojson['health_records'].length != 0) {
      debugPrint('รับคิวได้');
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
      var res = await http.post(url, body: {
        'public_id': context.read<DataProvider>().id,
        'care_unit_id': context.read<DataProvider>().care_unit_id
      });
      if (res.statusCode == 200) {
        ontap = false;
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            Navigator.pop(context);
          });
        });
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed('user_information');
        });
      }
    } else {
      debugPrint('รับคิวไม่ได้');
      Get.offNamed('healthrecord');
    }
  }

  Future<void> exam() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson2 = json.decode(res.body);
      debugPrint('+++++++' + resTojson2.toString());
      doctor_note = resTojson2['data']['doctor_note'];
      dx = resTojson2['data']['dx'];
      if (resTojson2 != null) {
        debugPrint(dx);
        debugPrint(doctor_note);
        setState(() {});
      }
    });
  }



  void printexam() async {
    String msgHead = "";
    String msgDetail = "";
    double sizeHeader = 20;
    double sizeBody = 14;

     if (selectedPrinter == null) {
      await _selectPrinter();
    }

    final pdf = pw.Document();

    // Define 80mm width and auto height for a thermal printer
    final pageFormat = PdfPageFormat(80 * PdfPageFormat.mm, double.infinity);

    //  msg =  'ส่วนสูง:${resToJsonCheckQuick["health_records"][0]["height"]} ';
    //  msg += ' น้ำหนัก:${resToJsonCheckQuick["health_records"][0]["weight"]}';
    //  msg += ' อุณภูมิ:${resToJsonCheckQuick["health_records"][0]["temp"]}';
     
     msgHead = 'HN : ${resTojson2['personal']['hn']} \n';
     msgHead += 'คุณ : ${resTojson2['personal']['first_name']} ${resTojson2['personal']['last_name']} \n';   
     
     msgDetail = 'น้ำหนัก : ${resTojson2['data']['weight']} | ส่วนสูง: ${resTojson2['data']['height']} \n';    
     msgDetail += 'อุณภูมิ : ${resTojson2['data']['temp']}  | BP: ${resTojson2['data']['bp']} \n';
     msgDetail += 'PULSE : ${resTojson2['data']['pulse_rate']}  | RR: ${resTojson2['data']['rr']} \n';      

    // Add a page with 80mm width
    pdf.addPage(
      pw.Page(
        pageFormat: pageFormat,
        build: (pw.Context context) {
          return pw.Column(
            //crossAxisAlignment: pw.CrossAxisAlignment.start,
            crossAxisAlignment: pw.CrossAxisAlignment.center,
            children: [
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'ผลการตรวจ',
              style: pw.TextStyle(font: thaiFont, fontSize: sizeHeader),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              msgHead,
              style: pw.TextStyle(font: thaiFont, fontSize: sizeBody),
              textAlign: pw.TextAlign.center,
            ),
          ),         
          pw.SizedBox(height: 3),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'อาการ \n $dx',
              style: pw.TextStyle(font: thaiFont, fontSize: sizeBody),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 3),
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              'Doctor Note \n $doctor_note',
              style: pw.TextStyle(font: thaiFont, fontSize: sizeBody),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 3),           
          pw.Align(
            alignment: pw.Alignment.center,
            child: pw.Text(
              msgDetail,
              style: pw.TextStyle(font: thaiFont, fontSize: sizeBody),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(height: 3),
        ],
          );
        },
      ),
    );

    // Convert the PDF to bytes
    final pdfBytes = await pdf.save();

    if (selectedPrinter != null) {
    await Printing.directPrintPdf(
      printer: selectedPrinter!,
      onLayout: (PdfPageFormat format) async => pdfBytes,
      );
    } else {
      print("No printer selected.");
    }

    // debugPrint("inti Printer");
    // List<int> bytes = [];

    // final profile = await CapabilityProfile.load(name: 'XP-N160I');
    // final generator = Generator(PaperSize.mm58, profile);

    // bytes += generator.text(context.read<DataProvider>().name_hospital,
    //     styles: const PosStyles(align: PosAlign.center));

    // bytes += generator.text('Examination',
    //     styles: const PosStyles(
    //         width: PosTextSize.size1, height: PosTextSize.size1));
    // bytes += generator.text('\n');
    // bytes += generator.text('Doctor  :  pairot tanyajasesn');
    // bytes += generator.text('Results :  $dx');
    // bytes += generator.text('        :  $doctor_note');
    // printer?.printTest(bytes);
  }

  // Future<void> printq() async {
  //   List<int> bytes = [];

  //   final profile = await CapabilityProfile.load(name: 'OFE6'); //XP-N160I
  //   final generator = Generator(PaperSize.mm58, profile);
  //   bytes += generator.text(context.read<DataProvider>().name_hospital,
  //       styles: const PosStyles(align: PosAlign.center));
  //   bytes += generator.text("Q ${resTojson['queue_number']}",
  //       styles: const PosStyles(
  //           align: PosAlign.center,
  //           width: PosTextSize.size6,
  //           height: PosTextSize.size6,
  //           fontType: PosFontType.fontA));
  //   bytes += generator.text('\n');
  //   bytes +=
  //       generator.text('Doctor :   ${resTojson['todays'][0]['doctor_name']}');
  //   bytes += generator.text(
  //       'Care   :  ${resTojson['todays'][0]['care_name']} / ( ${resTojson['todays'][0]['slot']} )');
  //   bytes += generator.text('\n');
  //   bytes += generator.text('Health Information',
  //       styles: const PosStyles(align: PosAlign.center));
  //   bytes += generator.row([
  //     PosColumn(
  //         width: 4,
  //         text: 'height',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: 'weight',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: 'temp',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //   ]);
  //   bytes += generator.row([
  //     PosColumn(
  //         width: 4,
  //         text: height,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: weight,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: temp,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //   ]);
  //   bytes += generator.row([
  //     PosColumn(
  //         width: 4,
  //         text: 'sys',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: 'dia',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: 'spo2',
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //   ]);
  //   bytes += generator.row([
  //     PosColumn(
  //         width: 4,
  //         text: sys,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: dia,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //     PosColumn(
  //         width: 4,
  //         text: spo2,
  //         styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
  //   ]);
  //   ontap = false;
  //   printer?.printTest(bytes);
  // }

  Future<void> _loadThaiFont() async {
    final fontData = await rootBundle.load('assets/fonts/THSarabunNew.ttf');
    print('_loadThaiFont');
    print(fontData);
    setState(() {
      thaiFont = pw.Font.ttf(fontData);
    });
  }

  // Function to get available printers
  Future<void> _selectPrinter() async {
    final printers = await Printing.listPrinters();
    
    print('select_printer....');
    if (printers.isNotEmpty) {
     
      print('Total printers found: ${printers.length}');
      for (var i = 0; i < printers.length; i++) {
        print('Printer $i: ${printers[i].name}');
      }

      final kposPrinter = printers.firstWhere(
        (printer) => printer.name == 'KPOS_80 Printer',
        orElse: () => printers.first, // Fallback to the first printer if not found
      );
   
      setState(() {
        //selectedPrinter =   printers.first;  //printers.first; // Select the first printer as default
        selectedPrinter = kposPrinter;
      });
    }
  }
  
  @override
  void initState() {
    checkQuick();
    // checkt_queue();
    // karn start
    _loadThaiFont();
    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        RawKeyboard.instance.addListener((RawKeyEvent event) {
          if (event.logicalKey == LogicalKeyboardKey.enter && event is RawKeyDownEvent) {
          //  _sendToSelectedPrinter();
          }
        });
      }
    });
    // karn end

    // printer = ESMPrinter([
    //   {'vendor_id': '19267', 'product_id': '14384'},
    // ]);

    super.initState();
  }

  @override
  void dispose() {
    timerCheckQuick?.cancel();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      body: Stack(
        children: [
          const backgrund(),
          Positioned(
              child: ListView(children: [
            SizedBox(
              height: height * 0.25,
              child: Column(
                children: [
                  BoxTime(),
                  BoxDecorate(
                      child: InformationCard(
                          dataidcard: context.read<DataProvider>().dataidcard)),
                ],
              ),
            ),
            context.read<DataProvider>().dataUserIDCard["claimTypes"].length !=
                    0
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: height * 0.5,
                      child: resToJsonCheckQuick != null
                          ? resToJsonCheckQuick["message"] == "completed" ||
                                  resToJsonCheckQuick["message"] == "finished"
                              ? ListView(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text("การตรวจเสร็จสิ้น",
                                              style: TextStyle(
                                                fontSize: width * 0.05,
                                                color: Color(0xff48B5AA),
                                              ))
                                        ],
                                      ),
                                    ),
                                    Center(
                                      child: Container(
                                        height: height * 0.3,
                                        width: width * 0.8,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          color: Colors.white,
                                          boxShadow: const [
                                            BoxShadow(
                                                blurRadius: 2,
                                                spreadRadius: 2,
                                                color: Color.fromARGB(
                                                    255, 188, 188, 188),
                                                offset: Offset(0, 2)),
                                          ],
                                        ),
                                        child: ListView(children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text("ผลการตรวจ",
                                                  style: TextStyle(
                                                      fontSize: width * 0.04)),
                                            ],
                                          ),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("DX :",
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03)),
                                                Text(dx,
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03)),
                                              ]),
                                          Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("Doctor Note :",
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03)),
                                                Text(doctor_note,
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03)),
                                              ]),
                                          SizedBox(height: height * 0.05),
                                          Center(
                                            child: ElevatedButton(
                                                onPressed: () {
                                                  printexam();
                                                },
                                                child: Text("ปริ้นผลตรวจ",
                                                    style: TextStyle(
                                                        fontSize:
                                                            width * 0.03))),
                                          )
                                        ]),
                                      ),
                                    ),
                                  ],
                                )
                              : resToJsonCheckQuick["message"] ==
                                      "health_record"
                                  ? ListView(
                                      children: [
                                        Container(
                                          width: width,
                                          height: height * 0.1,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  offset: Offset(0, 2)),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                                "${context.watch<DataProvider>().claimTypeName} (${context.watch<DataProvider>().claimType})",
                                                style: TextStyle(
                                                    fontSize: width * 0.03)),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              0, 10, 0, 0),
                                          child: Container(
                                              width: width,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                color: Colors.white,
                                                boxShadow: const [
                                                  BoxShadow(
                                                      blurRadius: 2,
                                                      spreadRadius: 2,
                                                      color: Color.fromARGB(
                                                          255, 188, 188, 188),
                                                      offset: Offset(0, 2)),
                                                ],
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  children: [
                                                    Text("ตรวจสอบข้อมูล",
                                                        style: TextStyle(
                                                            fontSize:
                                                                width * 0.04)),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("เลขบัตรประชาชน",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            context
                                                                .watch<
                                                                    DataProvider>()
                                                                .id,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("ชื่อ - นามสกุล",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            "${context.watch<DataProvider>().dataUserIDCard['fname']}  ${context.read<DataProvider>().dataUserIDCard['lname']}",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text(
                                                            "วันเดือนปีเกิด(ปปปป/ดด/วว)",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            "${context.watch<DataProvider>().dataUserIDCard['birthDate']} ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("claimType",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            context
                                                                .watch<
                                                                    DataProvider>()
                                                                .claimType,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("correlationId",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            context
                                                                    .watch<
                                                                        DataProvider>()
                                                                    .dataUserIDCard[
                                                                'correlationId'],
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("HN :",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            context
                                                                .read<
                                                                    DataProvider>()
                                                                .hn
                                                                .text,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text("เบอร์โทร : ",
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                        Text(
                                                            context
                                                                .read<
                                                                    DataProvider>()
                                                                .tel
                                                                .text,
                                                            style: TextStyle(
                                                                fontSize:
                                                                    width *
                                                                        0.03)),
                                                      ],
                                                    ),
                                                    SizedBox(
                                                        height: height * 0.02)
                                                  ],
                                                ),
                                              )),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              ElevatedButton(
                                                  style:
                                                      ElevatedButton.styleFrom(
                                                    backgroundColor:
                                                        Colors.green,
                                                  ),
                                                  onPressed: () {
                                                    if (resToJsonCheckQuick[
                                                            "message"] ==
                                                        "health_record") {
                                                      timerCheckQuick?.cancel();
                                                      Get.toNamed(
                                                          'healthRecord2');
                                                    }
                                                  },
                                                  child: Text(
                                                    "ยืนยัน",
                                                    style: TextStyle(
                                                      fontSize: width * 0.03,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),
                                      ],
                                    )
                                  : resToJsonCheckQuick["message"] == "waiting"
                                      ? Container(
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            color: Colors.white,
                                            boxShadow: const [
                                              BoxShadow(
                                                  blurRadius: 2,
                                                  spreadRadius: 2,
                                                  color: Color.fromARGB(
                                                      255, 188, 188, 188),
                                                  offset: Offset(0, 2)),
                                            ],
                                          ),
                                          child: ListView(children: [
                                            Text(
                                              " claimTypeName : ${context.watch<DataProvider>().claimTypeName} ",
                                              style: TextStyle(
                                                fontSize: width * 0.03,
                                              ),
                                            ),
                                            Text(
                                              "claimType :(${context.watch<DataProvider>().claimType})",
                                              style: TextStyle(
                                                fontSize: width * 0.03,
                                              ),
                                            ),
                                            Text(
                                              "claimCode :${context.watch<DataProvider>().claimCode} ",
                                              style: TextStyle(
                                                fontSize: width * 0.03,
                                              ),
                                            ),
                                            const Center(
                                              child: CircularProgressIndicator(
                                                color: Color.fromARGB(
                                                    255, 0, 139, 130),
                                              ),
                                            ),
                                          ]),
                                        )
                                      : resToJsonCheckQuick["message"] ==
                                              "processing"
                                          ? SizedBox(
                                              child: ListView(children: [
                                                Center(
                                                  child: Text(
                                                      'กด VideoCall เพื่อเข้าตรวจ',
                                                      style: TextStyle(
                                                          fontFamily: context
                                                              .read<
                                                                  DataProvider>()
                                                              .fontFamily,
                                                          fontSize:
                                                              width * 0.03,
                                                          color: const Color
                                                                  .fromARGB(255,
                                                              35, 131, 123))),
                                                ),
                                                Center(
                                                  child: ElevatedButton(
                                                      onPressed: () {
                                                        timerCheckQuick
                                                            ?.cancel();
                                                        Get.offNamed(
                                                            'preparation_videocall');
                                                      },
                                                      child: const Text(
                                                          "VideoCall")),
                                                )
                                              ]),
                                            )
                                          : const SizedBox()
                          : const Center(
                              child: CircularProgressIndicator(
                                color: Color.fromARGB(255, 0, 139, 130),
                              ),
                            ),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Container(
                          height: height * 0.08,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Colors.white,
                            boxShadow: const [
                              BoxShadow(
                                  blurRadius: 2,
                                  spreadRadius: 2,
                                  color: Color.fromARGB(255, 188, 188, 188),
                                  offset: Offset(0, 2)),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "${context.watch<DataProvider>().claimType} : ${context.watch<DataProvider>().claimTypeName}",
                              style: TextStyle(
                                fontSize: width * 0.03,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
            resTojson != null
                ? SizedBox(
                    height: height * 0.5,
                    child: Column(
                      children: [
                        status != ''
                            ? Column(
                                children: [
                                  BoxStatusinform(status: status),
                                  SizedBox(
                                    height: height * 0.01,
                                  ),
                                  ontap == true
                                      ? SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          child:
                                              const CircularProgressIndicator(
                                            color: Color(0xff76FFD5),
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              ontap = true;
                                            });
                                            exam();
                                          },
                                          child: Container(
                                              height: height * 0.05,
                                              width: width * 0.3,
                                              decoration: BoxDecoration(
                                                  color:
                                                      const Color(0xff31D6AA),
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  boxShadow: const [
                                                    BoxShadow(
                                                      color: Colors.grey,
                                                      offset: Offset(0, 4),
                                                      blurRadius: 5,
                                                    )
                                                  ]),
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    Image.asset(
                                                        'assets/jhb.png'),
                                                    Text('  ปริ้นผลตรวจ',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight.w500,
                                                            fontFamily: context
                                                                .read<
                                                                    DataProvider>()
                                                                .fontFamily,
                                                            fontSize:
                                                                width * 0.03,
                                                            color:
                                                                Colors.white))
                                                  ])),
                                        )
                                ],
                              )
                            : Column(
                                children: [
                                  const BoxToDay(),
                                  SizedBox(height: height * 0.01),
                                  ontap == false
                                      ? resTojson['todays'].length != 0
                                          ? resTojson['queue_number'] != ''
                                              ? GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      // ontap = true;
                                                    });
                                                    // printq();
                                                  },
                                                  child: Container(
                                                      height: height * 0.05,
                                                      width: width * 0.3,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xff31D6AA),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset:
                                                                  Offset(0, 4),
                                                              blurRadius: 5,
                                                            )
                                                          ]),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.asset(
                                                                'assets/jhb.png'),
                                                            Text('  ปริ้น',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily: context
                                                                        .read<
                                                                            DataProvider>()
                                                                        .fontFamily,
                                                                    fontSize:
                                                                        width *
                                                                            0.03,
                                                                    color: Colors
                                                                        .white))
                                                          ])),
                                                )
                                              : GestureDetector(
                                                  onTap: () {
                                                    setState(() {
                                                      ontap = true;
                                                    });
                                                    q();
                                                  },
                                                  child: Container(
                                                      height: height * 0.05,
                                                      width: width * 0.3,
                                                      decoration: BoxDecoration(
                                                          color: const Color(
                                                              0xff31D6AA),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(15),
                                                          boxShadow: const [
                                                            BoxShadow(
                                                              color:
                                                                  Colors.grey,
                                                              offset:
                                                                  Offset(0, 4),
                                                              blurRadius: 5,
                                                            )
                                                          ]),
                                                      child: Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .start,
                                                          children: [
                                                            Image.asset(
                                                                'assets/jhb.png'),
                                                            Text('  รับคิว',
                                                                style: TextStyle(
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w500,
                                                                    fontFamily: context
                                                                        .read<
                                                                            DataProvider>()
                                                                        .fontFamily,
                                                                    fontSize:
                                                                        width *
                                                                            0.03,
                                                                    color: Colors
                                                                        .white))
                                                          ])),
                                                )
                                          : const SizedBox()
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.07,
                                          child:
                                              const CircularProgressIndicator(
                                                  color: Color(0xff76FFD5)),
                                        )
                                ],
                              ),
                      ],
                    ),
                  )
                : const Text(""),
            SizedBox(
              height: height * 0.15,
              child: Column(
                children: [
                  choice(cancel: stop),
                ],
              ),
            ),
          ]))
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: height * 0.03,
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  _timer?.cancel();
                  context.read<Datafunction>().playsound();
                  setState(() {
                    context.read<DataProvider>().id = '';
                    Get.offNamed('home');
                  });
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
                    '< ออก',
                    style: TextStyle(
                        fontFamily: context.read<DataProvider>().fontFamily,
                        fontSize: width * 0.03,
                        color: const Color.fromARGB(255, 201, 201, 201)),
                  )),
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  timerCheckQuick?.cancel();
                  Get.toNamed('healthRecord2');
                },
                child: const Text("เทส Health Record")),
            ElevatedButton(
                onPressed: () {
                  timerCheckQuick?.cancel();
                  Get.toNamed('device_manager');
                },
                child: const Text("Devices"))
          ],
        ),
      ),
    ));
  }
}

class choice extends StatefulWidget {
  const choice({super.key, this.cancel});
  final VoidCallback? cancel;
  @override
  State<choice> createState() => _choiceState();
}

class _choiceState extends State<choice> {
  var resTojson;
  var resTojson2;
  String status = '';

  Future<void> getqueue() async {
    if (resTojson['health_records'].length == 0) {
      context.read<DataProvider>().status_getqueue = 'false';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ตรวจสุขภาพก่อนรับคิว',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().fontFamily,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
      Get.toNamed('healthrecord');
    } else {
      context.read<DataProvider>().status_getqueue = 'true';
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
        'public_id': context.read<DataProvider>().id,
      });
      if (res.statusCode == 200) {
        debugPrint('รับคิว รีเซ็ท');
        setState(() {
          resTojson = json.decode(res.body);
          context.read<DataProvider>().status_getqueue == 'true';
          Navigator.pop(context);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const UserInformation2()));
        });
      }
    }
  }

  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      if (resTojson != null) {}
    });
  }

  

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration1 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color.fromARGB(255, 245, 245, 245)),
      boxShadow: const [
        BoxShadow(
            color: Color(0xffFFA800),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    BoxDecoration boxDecoration2 = BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: const Color.fromARGB(255, 245, 245, 245)),
      boxShadow: const [
        BoxShadow(
            color: Color(0xff0076B1),
            offset: Offset(0, 3),
            spreadRadius: 1,
            blurRadius: 2)
      ],
    );
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().fontFamily,
        fontSize: width * 0.035,
        color: const Color(0xff1B6286));
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  context: context,
                  builder: (context) => Container(
                    height: height * 0.6,
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
                      const HeadBoxAppointments(),
                      BoxAppointments(),
                    ]),
                  ),
                );
              },
              child: Container(
                  height: height * 0.05,
                  width: width * 0.35,
                  decoration: boxDecoration1,
                  child: Row(
                    children: [
                      Image.asset('assets/pasd.png'),
                      Center(
                          child: Text(
                        'การนัดหมาย',
                        style: style,
                      )),
                    ],
                  )),
            ),
            SizedBox(
              width: width * 0.05,
            ),
            GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  backgroundColor: const Color.fromARGB(0, 255, 255, 255),
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  context: context,
                  builder: (context) => Container(
                    height: height * 0.6,
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
                      BoxShoHealth_Records(),
                    ]),
                  ),
                );
              },
              child: Container(
                  height: height * 0.05,
                  width: width * 0.35,
                  decoration: boxDecoration2,
                  child: Row(
                    children: [
                      Image.asset('assets/ksjope.png'),
                      Center(
                          child: Text(
                        'ประวัติสุขภาพ',
                        style: style,
                      )),
                    ],
                  )),
            ),
          ],
        ),
      ],
    );
  }
}
