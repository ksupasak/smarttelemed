// // ignore_for_file: non_constant_identifier_names, prefer_typing_uninitialized_variables, use_build_context_synchronously, must_be_immutable

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';

// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';

// import 'package:smart_health/station/provider/provider.dart';

// import 'package:http/http.dart' as http;
// import 'package:smart_health/station/test/esm_printer.dart';
// import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

// class PrintQueue extends StatefulWidget {
//   const PrintQueue({super.key});

//   @override
//   State<PrintQueue> createState() => _PrintQueueState();
// }

// class _PrintQueueState extends State<PrintQueue> {
//   var resTojson;

//   DateTime dateTime = DateTime.parse('0000-00-00 00:00');
//   String datatime = "";
//   ESMPrinter? printer;
//   var devices = <BluetoothPrinter>[];
//   List default_deivces = [];
//   BluetoothPrinter? selectedPrinter;
//   String height = '';
//   String weight = '';
//   String temp = '';
//   String bp_sys = '';
//   String bp_dia = '';
//   String spo2 = '';
//   Future<void> checkt_queue() async {
//     var url =
//         Uri.parse('${context.read<DataProvider>().platfromURL}/Api/check_q');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       resTojson = json.decode(res.body); //เเก้2

//       Deviceprint();
//     });
//   }

//   void selectDevice(BluetoothPrinter device) async {
//     if (selectedPrinter != null) {
//       if ((device.address != selectedPrinter!.address) ||
//           (device.typePrinter == PrinterType.usb &&
//               selectedPrinter!.vendorId != device.vendorId)) {
//         await PrinterManager.instance
//             .disconnect(type: selectedPrinter!.typePrinter);
//       }
//     }

//     selectedPrinter = device;
//     // setState(() {});
//   }

//   void Deviceprint() {
//     debugPrint('call print test');
//     if (selectedPrinter == null) {
//       for (final device in devices) {
//         var vendorId = device.vendorId;
//         var productId = device.productId;
//         debugPrint('scan for $vendorId $productId');
//         for (final s in default_deivces) {
//           if (s['vendor_id'] == vendorId && s['product_id'] == productId) {
//             debugPrint('found ');
//             selectDevice(device);
//           }
//         }
//       }
//     }

//     if (resTojson['health_records'].length != 0) {
//       setState(() {
//         resTojson['health_records'][0]['height'] == null
//             ? height = ''
//             : height = resTojson['health_records'][0]['height'];
//         resTojson['health_records'][0]['weight'] == null
//             ? weight = ''
//             : weight = resTojson['health_records'][0]['weight'];
//         resTojson['health_records'][0]['temp'] == null
//             ? temp = ''
//             : temp = resTojson['health_records'][0]['temp'];
//         resTojson['health_records'][0]['bp_sys'] == null
//             ? bp_sys = ''
//             : bp_sys = resTojson['health_records'][0]['bp_sys'];
//         resTojson['health_records'][0]['bp_dia'] == null
//             ? bp_dia = ''
//             : bp_dia = resTojson['health_records'][0]['bp_dia'];
//         resTojson['health_records'][0]['spo2'] == null
//             ? spo2 = ''
//             : spo2 = resTojson['health_records'][0]['spo2'];
//       });
//       printqueue();
//     } else {
//       printqueue();
//     }
//   }

//   void printqueue() async {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: SizedBox(
//             width: MediaQuery.of(context).size.width,
//             child: Center(
//                 child: Text(
//               'ปริ้นผลตรวจ',
//               style: TextStyle(
//                   fontFamily: context.read<DataProvider>().fontFamily,
//                   fontSize: MediaQuery.of(context).size.width * 0.03),
//             )))));
//     List<int> bytes = [];

//     final profile = await CapabilityProfile.load(name: 'XP-N160I');

//     final generator = Generator(PaperSize.mm58, profile);

//     bytes += generator.text(context.read<DataProvider>().name_hospital,
//         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.text('');
//     bytes += generator.text("Q ${resTojson['queue_number']}",
//         styles: const PosStyles(
//             align: PosAlign.center,
//             width: PosTextSize.size3,
//             height: PosTextSize.size3,
//             fontType: PosFontType.fontA));
//     bytes += generator.text('\n');
//     bytes += generator.text('Doctor :  ');
//     bytes += generator.text(
//         'Care   :  ${resTojson['todays'][0]['care_name']} / ( ${resTojson['todays'][0]['slot']} )');
//     bytes += generator.text('\n');
//     bytes += generator.text('Health Information',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += generator.row([
//       PosColumn(
//           width: 2,
//           text: 'height',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'weight',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'temp',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'sys',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'dia',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'spo2',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           width: 2,
//           text: height,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: weight,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: temp,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: bp_sys,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: bp_dia,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: spo2,
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//     ]);

//     printer?.printTest(bytes);
//   }

//   @override
//   void initState() {
//     startTimer();
//     printer = ESMPrinter([
//       // {'vendor_id': '1121', 'product_id': '19841'},
//       // {'vendor_id': '8746', 'product_id': '1'},
//       {'vendor_id': '19267', 'product_id': '14384'},
//       // {'vendor_id': '1137', 'product_id': '85'},
//     ]);
//     checkt_queue();
//     setState(() {
//       dateTime = DateTime.now();
//       datatime = "${dateTime.hour}: "
//           "${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}";
//     });
//     super.initState();
//   }

//   Widget queue() {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     TextStyle stylequeue = TextStyle(
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: width * 0.07);
//     TextStyle nameHospital = TextStyle(
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: width * 0.05);
//     TextStyle text = TextStyle(
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: width * 0.02);
//     return Container(
//       height: height * 0.5,
//       width: width * 0.8,
//       color: const Color.fromARGB(255, 250, 250, 250),
//       child: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceAround,
//         children: [
//           Row(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Container(width: width * 0.1),
//               Text(context.read<DataProvider>().name_hospital,
//                   style: nameHospital),
//               SizedBox(
//                   width: width * 0.1,
//                   height: height * 0.04,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.end,
//                     children: [
//                       Text(
//                         datatime,
//                         style: TextStyle(
//                             fontFamily: context.read<DataProvider>().fontFamily,
//                             fontSize: width * 0.015),
//                       ),
//                     ],
//                   )),
//             ],
//           ),
//           Text('คิวที่', style: stylequeue),
//           Text(resTojson['queue_number'], style: stylequeue),
//           Row(mainAxisAlignment: MainAxisAlignment.center, children: [
//             Text('${resTojson['personal']['first_name']}  ', style: text),
//             Text('  ${resTojson['personal']['last_name']}', style: text)
//           ]),
//           Column(
//             children: [
//               Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
//                 Health(child: Text('height', style: text)),
//                 Health(child: Text('weight', style: text)),
//                 Health(child: Text('temp', style: text)),
//                 Health(child: Text('sys.', style: text)),
//                 Health(child: Text('dia', style: text)),
//                 Health(child: Text('spo2', style: text)),
//               ]),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                   children: resTojson['health_records'].length != 0
//                       ? [
//                           resTojson['health_records'][0]['height'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['height']}',
//                                       style: text)),
//                           resTojson['health_records'][0]['weight'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['weight']}',
//                                       style: text),
//                                 ),
//                           resTojson['health_records'][0]['temp'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['temp']}',
//                                       style: text),
//                                 ),
//                           resTojson['health_records'][0]['bp_dia'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['bp_dia']}',
//                                       style: text),
//                                 ),
//                           resTojson['health_records'][0]['bp_sys'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['bp_sys']}',
//                                       style: text),
//                                 ),
//                           resTojson['health_records'][0]['spo2'] == null
//                               ? Health(child: const Text(' - '))
//                               : Health(
//                                   child: Text(
//                                       '${resTojson['health_records'][0]['spo2']}',
//                                       style: text),
//                                 ),
//                         ]
//                       : []),
//             ],
//           )
//         ],
//       ),
//     );
//   }

//   int remainingSeconds = 5;
//   Timer? timer;
//   void startTimer() {
//     timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
//       setState(() {
//         remainingSeconds--;
//       });

//       if (remainingSeconds == 0) {
//         timer!.cancel();
//         Get.offNamed('home');
//       }
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;

//     return SafeArea(
//       child: Scaffold(
//         body: Stack(children: [
//           const backgrund(),
//           Positioned(
//               child: Center(
//                   child: SizedBox(
//             height: height * 0.8,
//             width: width * 0.8,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 resTojson == null
//                     ? Container(height: height * 0.5, width: width * 0.8)
//                     : queue(),
//                 SizedBox(height: height * 0.05),
//                 Text(
//                   'กำลังออกใน: $remainingSeconds วินาที',
//                   style: TextStyle(
//                       fontSize: width * 0.04,
//                       fontFamily: context.read<DataProvider>().fontFamily),
//                 ),
//               ],
//             ),
//           ))),
//         ]),
//       ),
//     );
//   }
// }

// class Health extends StatefulWidget {
//   Health({super.key, required this.child});
//   Widget child;
//   @override
//   State<Health> createState() => _HealthState();
// }

// class _HealthState extends State<Health> {
//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     return SizedBox(
//       width: width * 0.13,
//       child: Center(child: widget.child),
//     );
//   }
// }
