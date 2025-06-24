// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:smart_health/station/background/background.dart';
// import 'package:smart_health/station/background/color/style_color.dart';
// import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/esc_pos_utils_platform.dart';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
// import 'package:image/image.dart' as img;
// import 'image_utils.dart';

// import 'dart:async';
// import 'dart:developer';
// import 'dart:io';

// class ESMPrinter {
//   var printerManager = PrinterManager.instance;
//   var defaultPrinterType = PrinterType.usb;

//   var devices = <BluetoothPrinter>[];
//   StreamSubscription<PrinterDevice>? _subscription;
//   StreamSubscription<USBStatus>? _subscriptionUsbStatus;

//   BluetoothPrinter? selectedPrinter;
//   BTStatus _currentStatus = BTStatus.none;
//   USBStatus _currentUsbStatus = USBStatus.none;
//   List<int>? pendingTask;

//   var _isBle = false;
//   var _reconnect = false;
//   var _isConnected = false;

//   List default_deivces = [];

//   ESMPrinter(List devices) {
//     debugPrint('=========>init printer');

//     default_deivces = devices;

// //  PrinterManager.instance.stateUSB is only supports on Android
//     _subscriptionUsbStatus = PrinterManager.instance.stateUSB.listen((status) {
//       log(' ----------------- status usb ${status} ------------------ ');
//       debugPrint(' ----------------- status usb ${status} ------------------ ');
//       _currentUsbStatus = status;
//       if (Platform.isAndroid) {
//         if (status == USBStatus.connected && pendingTask != null) {
//           Future.delayed(const Duration(milliseconds: 1000), () {
//             PrinterManager.instance
//                 .send(type: PrinterType.usb, bytes: pendingTask!);
//             pendingTask = null;
//           });
//         }
//       }
//     });

//     scan();
//   }

//   void scan() {
//     debugPrint('====scan');

//     devices.clear();
//     _subscription = printerManager
//         .discovery(type: defaultPrinterType, isBle: _isBle)
//         .listen((device) {
//       devices.add(BluetoothPrinter(
//         deviceName: device.name,
//         address: device.address,
//         isBle: _isBle,
//         vendorId: device.vendorId,
//         productId: device.productId,
//         typePrinter: defaultPrinterType,
//       ));
//       debugPrint(
//           'found printer ${device.name} ${device.vendorId} ${device.productId} ');
//     });
//   }

//   void printTest(List<int> data) {
//     debugPrint(
//         'call print test ${selectedPrinter.toString()} ${devices.length}');
//     if (selectedPrinter == null) {
//       for (final device in devices) {
//         var vendor_id = device.vendorId;
//         var product_id = device.productId;
//         debugPrint('scan for ${vendor_id} ${product_id}');
//         if (default_deivces != null) {
//           for (final s in default_deivces) {
//             debugPrint(
//                 'scan for ${vendor_id} ${product_id} ${s['vendor_id']}  ${s['product_id']} ');
//             if (s['vendor_id'] == vendor_id.toString() &&
//                 s['product_id'] == product_id.toString()) {
//               debugPrint('======found ');

//               selectDevice(device);
//             }
//           }
//         }
//       }
//     }

//     if (selectedPrinter != null) {
//       print('ปริ้น');
//       _printReceiveTest(data);
//     } else {
//       print('ไม่ปริ้น');
//     }
//   }

//   Future _printReceiveTest(List<int> datas) async {
//     List<int> bytes = [];

//     // Xprinter XP-N160I
//     final profile =
//         await CapabilityProfile.load(name: 'XP-N160I'); // Thermal_Printer

//     // PaperSize.mm80 or PaperSize.mm58
//     final generator = Generator(PaperSize.mm58, profile);
//     bytes += generator.setGlobalCodeTable('CP1252');
//     bytes += datas;
//     // bytes += generator.text('Test Print',
//     //     styles: const PosStyles(align: PosAlign.right));
//     // bytes += generator.text('Product 1');
//     // bytes += generator.text('Product 2');

//     // // bytes += generator.text('￥1,990', containsChinese: true, styles: const PosStyles(align: PosAlign.left));
//     // // bytes += generator.emptyLines(1);

//     // // sum width total column must be 12
//     // bytes += generator.row([
//     //   PosColumn(
//     //       width: 8,
//     //       text: 'Lemon lime export quality per pound x 5 units',
//     //       styles: const PosStyles(align: PosAlign.left, codeTable: 'CP1252')),
//     //   PosColumn(
//     //       width: 4,
//     //       text: 'USD 2.00',
//     //       styles: const PosStyles(align: PosAlign.right, codeTable: 'CP1252')),
//     // ]);

//     // final ByteData data = await rootBundle.load('assets/ic_launcher.png');
//     // if (data.lengthInBytes > 0) {
//     //   final Uint8List imageBytes = data.buffer.asUint8List();
//     //   // decode the bytes into an image
//     //   final decodedImage = img.decodeImage(imageBytes)!;
//     //   // Create a black bottom layer
//     //   // Resize the image to a 130x? thumbnail (maintaining the aspect ratio).
//     //   img.Image thumbnail = img.copyResize(decodedImage, height: 130);
//     //   // creates a copy of the original image with set dimensions
//     //   img.Image originalImg =
//     //       img.copyResize(decodedImage, width: 380, height: 130);
//     //   // fills the original image with a white background
//     //   img.fill(originalImg, color: img.ColorRgb8(255, 255, 255));
//     //   var padding = (originalImg.width - thumbnail.width) / 2;

//     //   //insert the image inside the frame and center it
//     //   drawImage(originalImg, thumbnail, dstX: padding.toInt());

//     //   // convert image to grayscale
//     //   var grayscaleImage = img.grayscale(originalImg);

//     //   bytes += generator.feed(1);
//     //   // bytes += generator.imageRaster(img.decodeImage(imageBytes)!, align: PosAlign.center);
//     //   bytes += generator.imageRaster(grayscaleImage, align: PosAlign.center);
//     //   bytes += generator.feed(1);
//     // }

//     // // // Chinese characters
//     // bytes += generator.row([
//     //   PosColumn(
//     //       width: 8,
//     //       text: '豚肉・木耳と玉子炒め弁当',
//     //       styles: const PosStyles(align: PosAlign.left),
//     //       containsChinese: true),
//     //   PosColumn(
//     //       width: 4,
//     //       text: '￥1,990',
//     //       styles: const PosStyles(align: PosAlign.right),
//     //       containsChinese: true),
//     // ]);
//     printEscPos(bytes, generator);
//   }

//   /// print ticket
//   void printEscPos(List<int> bytes, Generator generator) async {
//     print('จุด1 ${selectedPrinter.toString()}');
//     var connectedTCP = false;
//     if (selectedPrinter == null) return;
//     var bluetoothPrinter = selectedPrinter!;

//     switch (bluetoothPrinter.typePrinter) {
//       case PrinterType.usb:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: UsbPrinterInput(
//                 name: bluetoothPrinter.deviceName,
//                 productId: bluetoothPrinter.productId,
//                 vendorId: bluetoothPrinter.vendorId));
//         pendingTask = null;
//         break;
//       case PrinterType.bluetooth:
//         bytes += generator.cut();
//         await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: BluetoothPrinterInput(
//                 name: bluetoothPrinter.deviceName,
//                 address: bluetoothPrinter.address!,
//                 isBle: bluetoothPrinter.isBle ?? false,
//                 autoConnect: _reconnect));
//         pendingTask = null;
//         if (Platform.isAndroid) pendingTask = bytes;
//         break;
//       case PrinterType.network:
//         bytes += generator.feed(2);
//         bytes += generator.cut();
//         connectedTCP = await printerManager.connect(
//             type: bluetoothPrinter.typePrinter,
//             model: TcpPrinterInput(ipAddress: bluetoothPrinter.address!));
//         if (!connectedTCP) print(' --- please review your connection ---');
//         break;
//       default:
//     }
//     if (bluetoothPrinter.typePrinter == PrinterType.bluetooth &&
//         Platform.isAndroid) {
//       if (_currentStatus == BTStatus.connected) {
//         printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//         pendingTask = null;
//       }
//     } else {
//       printerManager.send(type: bluetoothPrinter.typePrinter, bytes: bytes);
//     }
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
//     debugPrint(
//         ' ----------------- selectedPrinter ${device.toString()} ------------------ ');
//     selectedPrinter = device;
//     // setState(() {});
//   }
// }

// class BluetoothPrinter {
//   int? id;
//   String? deviceName;
//   String? address;
//   String? port;
//   String? vendorId;
//   String? productId;
//   bool? isBle;

//   PrinterType typePrinter;
//   bool? state;

//   BluetoothPrinter(
//       {this.deviceName,
//       this.address,
//       this.port,
//       this.state,
//       this.vendorId,
//       this.productId,
//       this.typePrinter = PrinterType.bluetooth,
//       this.isBle = false});
// }
