// // ignore_for_file: camel_case_types, prefer_typing_uninitialized_variables, non_constant_identifier_names, use_build_context_synchronously

// import 'dart:async';
// import 'dart:convert';

// import 'package:flutter/material.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_health/station/provider/provider.dart';
// import 'package:smart_health/station/test/esm_printer.dart';
// import 'package:http/http.dart' as http;
// import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

// class Print_Exam extends StatefulWidget {
//   const Print_Exam({super.key});

//   @override
//   State<Print_Exam> createState() => _Print_ExamState();
// }

// class _Print_ExamState extends State<Print_Exam> {
//   String datatime = "";
//   ESMPrinter? printer;
//   var resTojson;
//   String doctor_note = '--';
//   String dx = '--';
//   BluetoothPrinter? selectedPrinter;
//   var devices = <BluetoothPrinter>[];
//   List default_deivces = [];

//   Future<void> finished() async {
//     var url =
//         Uri.parse('${context.read<DataProvider>().platfromURL}/finish_appoint');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       resTojson = json.decode(res.body);
//     });
//   }

//   Future<void> get_exam() async {
//     var url = Uri.parse(
//         '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       resTojson = json.decode(res.body);
//       doctor_note = resTojson['data']['doctor_note'];
//       dx = resTojson['data']['dx'];
//       if (resTojson != null) {
//         startTimer();
//         Deviceprint();
//       }
//     });
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

//     printexam();
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
//   }

//   void printexam() async {
//     List<int> bytes = [];
//     final profile = await CapabilityProfile.load(name: 'XP-N160I');
//     final generator = Generator(PaperSize.mm58, profile);
//     bytes += generator.text(context.read<DataProvider>().name_hospital,
//         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.text('Examination',
//         styles: const PosStyles(
//             width: PosTextSize.size1, height: PosTextSize.size1));
//     bytes += generator.text('\n');
//     bytes += generator.text('Doctor  :  pairot tanyajasesn');
//     bytes += generator.text('Results :  $dx');
//     bytes += generator.text('        :  $doctor_note');
//     printer?.printTest(bytes);
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
//   void initState() {
//     finished();

//     printer = ESMPrinter([
//       {'vendor_id': '1137', 'product_id': '85'}
//     ]);
//     get_exam();
//     setState(() {
//       var dateTime = DateTime.now();
//       datatime = "${dateTime.hour}: "
//           "${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}";
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//           body: Stack(
//         children: [
//           const backgrund(),
//           Positioned(
//               child: SizedBox(
//             width: width,
//             height: height,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Container(
//                   height: height * 0.5,
//                   width: width * 0.8,
//                   decoration: BoxDecoration(
//                       color: const Color.fromARGB(255, 243, 243, 243),
//                       borderRadius: BorderRadius.circular(10)),
//                 ),
//                 SizedBox(height: height * 0.01),
//                 Text(
//                   'กำลังออกใน: $remainingSeconds วินาที',
//                   style: TextStyle(
//                       fontSize: width * 0.04,
//                       fontFamily: context.read<DataProvider>().fontFamily),
//                 ),
//               ],
//             ),
//           ))
//         ],
//       )),
//     );
//   }
// }
