// import 'dart:async';

// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:smarttelemed/myapp/provider/provider.dart';
// import 'package:smarttelemed/myapp/setting/device/blue_on.dart';
// import 'package:smarttelemed/myapp/setting/device/requestLocationPermission.dart';
// import 'package:smarttelemed/myapp/setting/local.dart';

// class ScanBLE extends StatefulWidget {
//   const ScanBLE({super.key});

//   @override
//   State<ScanBLE> createState() => _ScanBLEState();
// }

// class _ScanBLEState extends State<ScanBLE> {
//   bool button = false;
//   bool refresh = false;
//   List<String> namescan = DataProvider().namescan;
//   List<ScanResult> listscan = [];
//   List<BluetoothDevice> connected = [];
//   Map<String, String> listadddevice = {};
//   StreamSubscription? _functionscanconnected;
//   String titleappbar = '';
//   void scan() {
//     setState(() {
//       titleappbar = 'กำลังค้นหาอุปกรณ์...';
//       button = true;
//       refresh = true;
//     });
//     Future.delayed(const Duration(seconds: 5), () {
//       setState(() {
//         button = false;
//         refresh = false;
//         scanconnected();
//       });
//     });
//     print('กำลังเเสกน');
//     FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
//     FlutterBluePlus.instance.scanResults.listen((results) {
//       if (results.length > 0) {
//         ScanResult r = results.last;

//         if (namescan.contains(r.device.name.toString())) {
//           print('เจอdeviceที่กำหนด');
//           print("name= ${r.device.name} id= ${r.device.id}");
//           if (!listscan.contains(r)) {
//             listscan.add(r);
//           }
//         }
//         if (r.device.name.toString().length >= 15) {
//           if ('Yuwell BO-YX110' == r.device.name.toString().substring(0, 15)) {
//             if (!listscan.contains(r)) {
//               listscan.add(r);
//             }
//           }
//         }
//       }
//     });
//   }

//   Future<void> scanconnected() async {
//     List<BluetoothDevice> devices =
//         await FlutterBluePlus.instance.connectedDevices;
//     setState(() {
//       button = true;
//       refresh = true;
//     });
//     Future.delayed(const Duration(seconds: 2), () {
//       setState(() {
//         titleappbar = 'ค้นหาเสร็จสิ้น';
//         button = false;
//         refresh = false;
//       });
//     });
//     print('กำลังเเสกนdeviceที่เคยconnect');

//     // _functionscanconnected = Stream.periodic(Duration(seconds: 4))
//     //     .asyncMap((_) => FlutterBluePlus.instance.connectedDevices)
//     //     .listen((connectedDevices) {
//     //   print(connectedDevices);
//     // });

//     setState(() {
//       connected = [];
//       print(devices.length);
//       devices.forEach((device) {
//         print(device.id);
//         connected.add(device);
//       });
//     });
//   }

//   Future<void> adddevice(String name, String id) async {
//     final db = await openDatabasedevice();
//     final store = intMapStoreFactory.store('smart_healt_device');
//     var records = await store.find(db);

//     Map<String, Object?> mapdevices = {};

//     for (RecordSnapshot<int, Map<String, Object?>> record in records) {
//       var getmapd = record['mapdevices'];
//       if (getmapd != null) {
//         mapdevices = Map.fromEntries((getmapd as Map<String, Object?>).entries);
//       }
//     }

//     mapdevices[name] = id;
//     final key = await store.update(db, {
//       'mapdevices': mapdevices,
//     });

//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Center(
//                     child: Text(
//                   'เพิ่ม $name $id เเล้ว',
//                 )))));
//       });
//     });
//     await db.close();
//   }

//   @override
//   void initState() {
//     requestLocationPermission();
//     print('เข้าหน้าเเสกน');
//     scan();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         title: Text(
//           titleappbar,
//           style: TextStyle(color: Colors.black),
//         ),
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   scan();
//                 });
//               },
//               child: refresh == false
//                   ? Icon(
//                       Icons.search,
//                       color: Colors.black,
//                     )
//                   : Container(
//                       width: _width * 0.1,
//                       child: Center(
//                         child: CircularProgressIndicator(
//                           color: Colors.black,
//                         ),
//                       ),
//                     ),
//             ),
//           ),
//         ],
//       ),
//       backgroundColor: Colors.white,
//       body: ListView(children: [
//         Column(
//           children: [
//             Container(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: listscan.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return Column(
//                     children: [
//                       ListTile(
//                         title: Container(
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               color: Colors.white,
//                               boxShadow: [
//                                 BoxShadow(
//                                     color: Color.fromARGB(255, 42, 100, 45),
//                                     blurRadius: 1,
//                                     offset: Offset(0, 1))
//                               ]),
//                           child: Padding(
//                             padding: const EdgeInsets.all(0.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.start,
//                               children: [
//                                 Container(
//                                   height: _height * 0.1,
//                                   width: _width * 0.2,
//                                   child: context
//                                                   .read<DataProvider>()
//                                                   .imagesdevice[
//                                               listscan[index].device.name] !=
//                                           ''
//                                       ? Padding(
//                                           padding: const EdgeInsets.all(8.0),
//                                           child: listscan[index]
//                                                       .device
//                                                       .name
//                                                       .length >=
//                                                   15
//                                               ? 'Yuwell BO-YX110' ==
//                                                       listscan[index]
//                                                           .device
//                                                           .name
//                                                           .substring(0, 15)
//                                                   ? Image.asset(
//                                                       "assets/LINE_ALBUM_yuwell_230619.jpg")
//                                                   : Image.asset(
//                                                       "assets/${context.read<DataProvider>().imagesdevice[listscan[index].device.name]}")
//                                               : Image.asset(
//                                                   "assets/${context.read<DataProvider>().imagesdevice[listscan[index].device.name]}"),
//                                         )
//                                       : SizedBox(),
//                                 ),
//                                 Container(
//                                   width: _width * 0.6,
//                                   child: Column(
//                                     crossAxisAlignment:
//                                         CrossAxisAlignment.start,
//                                     children: [
//                                       listscan[index].device.name.length >= 15
//                                           ? 'Yuwell BO-YX110' ==
//                                                   listscan[index]
//                                                       .device
//                                                       .name
//                                                       .substring(0, 15)
//                                               ? Text('เครื่องวัดspo2')
//                                               : Text(context
//                                                   .read<DataProvider>()
//                                                   .namedevice[listscan[index]
//                                                       .device
//                                                       .name]
//                                                   .toString())
//                                           : Text(context
//                                               .read<DataProvider>()
//                                               .namedevice[
//                                                   listscan[index].device.name]
//                                               .toString()),
//                                       Text(
//                                           "Name : ${listscan[index].device.name}"),
//                                       Text(
//                                           "Id : ${listscan[index].device.id.toString()}"),
//                                     ],
//                                   ),
//                                 ),
//                                 GestureDetector(
//                                     onTap: () {
//                                       showDialog(
//                                           context: context,
//                                           builder: (BuildContext context) {
//                                             return AlertDialog(
//                                                 title: Text(
//                                                   'เพิ่มอุปกรณ์',
//                                                   style: TextStyle(
//                                                       color: Colors.black),
//                                                 ),
//                                                 content: Container(
//                                                   color: Colors.white,
//                                                   width: _width * 0.6,
//                                                   height: _height * 0.08,
//                                                   child: Row(
//                                                     children: [
//                                                       Container(
//                                                         height: _height * 0.1,
//                                                         width: _width * 0.1,
//                                                         child: context
//                                                                     .read<
//                                                                         DataProvider>()
//                                                                     .imagesdevice[listscan[
//                                                                         index]
//                                                                     .device
//                                                                     .name] !=
//                                                                 ''
//                                                             ? Padding(
//                                                                 padding:
//                                                                     const EdgeInsets
//                                                                             .all(
//                                                                         8.0),
//                                                                 child: listscan[index]
//                                                                             .device
//                                                                             .name
//                                                                             .length >=
//                                                                         15
//                                                                     ? 'Yuwell BO-YX110' ==
//                                                                             listscan[index].device.name.substring(0,
//                                                                                 15)
//                                                                         ? Image.asset(
//                                                                             "assets/LINE_ALBUM_yuwell_230619.jpg")
//                                                                         : Image.asset(
//                                                                             "assets/${context.read<DataProvider>().imagesdevice[listscan[index].device.name]}")
//                                                                     : Image.asset(
//                                                                         "assets/${context.read<DataProvider>().imagesdevice[listscan[index].device.name]}"),
//                                                               )
//                                                             : SizedBox(),
//                                                       ),
//                                                       Column(
//                                                         crossAxisAlignment:
//                                                             CrossAxisAlignment
//                                                                 .start,
//                                                         children: [
//                                                           listscan[index]
//                                                                       .device
//                                                                       .name
//                                                                       .length >=
//                                                                   15
//                                                               ? 'Yuwell BO-YX110' ==
//                                                                       listscan[index]
//                                                                           .device
//                                                                           .name
//                                                                           .substring(
//                                                                               0,
//                                                                               15)
//                                                                   ? Text(
//                                                                       'เครื่องวัดspo2')
//                                                                   : Text(context
//                                                                       .read<
//                                                                           DataProvider>()
//                                                                       .namedevice[listscan[index]
//                                                                           .device
//                                                                           .name]
//                                                                       .toString())
//                                                               : Text(context
//                                                                   .read<
//                                                                       DataProvider>()
//                                                                   .namedevice[
//                                                                       listscan[
//                                                                               index]
//                                                                           .device
//                                                                           .name]
//                                                                   .toString()),
//                                                           Text(
//                                                               "${listscan[index].device.name}"),
//                                                           Text(
//                                                               "${listscan[index].device.id.toString()}"),
//                                                         ],
//                                                       ),
//                                                     ],
//                                                   ),
//                                                 ),
//                                                 actions: [
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: GestureDetector(
//                                                         onTap: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                           adddevice(
//                                                               listscan[index]
//                                                                   .device
//                                                                   .name,
//                                                               listscan[index]
//                                                                   .device
//                                                                   .id
//                                                                   .toString());
//                                                         },
//                                                         child: Text('เพิ่ม')),
//                                                   ),
//                                                   Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: GestureDetector(
//                                                         onTap: () {
//                                                           Navigator.pop(
//                                                               context);
//                                                         },
//                                                         child: Text('กลับ')),
//                                                   )
//                                                 ]);
//                                           });
//                                     },
//                                     child: Container(
//                                       width: _width * 0.1,
//                                       height: _height * 0.05,
//                                       color: Colors.white,
//                                       child: Icon(
//                                         Icons.add,
//                                         color: Colors.green,
//                                       ),
//                                     ))
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ],
//                   );
//                 },
//               ),
//             ),
//             Container(
//               child: ListView.builder(
//                 shrinkWrap: true,
//                 itemCount: connected.length,
//                 itemBuilder: (BuildContext context, int index) {
//                   return context
//                               .read<DataProvider>()
//                               .namedevice[connected[index].name] !=
//                           null
//                       ? Column(
//                           children: [
//                             ListTile(
//                               title: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color:
//                                               Color.fromARGB(255, 42, 100, 45),
//                                           blurRadius: 1,
//                                           offset: Offset(0, 1))
//                                     ]),
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(0.0),
//                                   child: Row(
//                                     children: [
//                                       Container(
//                                         height: _height * 0.1,
//                                         width: _width * 0.2,
//                                         child: context
//                                                     .read<DataProvider>()
//                                                     .imagesdevice ==
//                                                 ''
//                                             ? SizedBox()
//                                             : Padding(
//                                                 padding:
//                                                     const EdgeInsets.all(8.0),
//                                                 child: Image.asset(
//                                                     "assets/${context.read<DataProvider>().imagesdevice[connected[index].name]}"),
//                                               ),
//                                       ),
//                                       Container(
//                                         width: _width * 0.6,
//                                         child: Column(
//                                           crossAxisAlignment:
//                                               CrossAxisAlignment.start,
//                                           children: [
//                                             Text(context
//                                                 .read<DataProvider>()
//                                                 .namedevice[
//                                                     connected[index].name]
//                                                 .toString()),
//                                             Text(
//                                                 "Name : ${connected[index].name}"),
//                                             Text("Id :  ${connected[index].id}")
//                                           ],
//                                         ),
//                                       ),
//                                       GestureDetector(
//                                           onTap: () {
//                                             showDialog(
//                                                 context: context,
//                                                 builder:
//                                                     (BuildContext context) {
//                                                   return AlertDialog(
//                                                       title: Text(
//                                                         'เพิ่มอุปกรณ์',
//                                                         style: TextStyle(
//                                                             color:
//                                                                 Colors.black),
//                                                       ),
//                                                       content: Container(
//                                                         color: Colors.white,
//                                                         width: _width * 0.6,
//                                                         height: _height * 0.08,
//                                                         child: Row(
//                                                           children: [
//                                                             Container(
//                                                               height:
//                                                                   _height * 0.1,
//                                                               width:
//                                                                   _width * 0.1,
//                                                               child: context
//                                                                           .read<
//                                                                               DataProvider>()
//                                                                           .imagesdevice[connected[
//                                                                               index]
//                                                                           .name] ==
//                                                                       ''
//                                                                   ? Image.asset(
//                                                                       "assets/${context.read<DataProvider>().imagesdevice[connected[index].name]}")
//                                                                   : SizedBox(),
//                                                             ),
//                                                             Column(
//                                                               crossAxisAlignment:
//                                                                   CrossAxisAlignment
//                                                                       .start,
//                                                               children: [
//                                                                 Text(context
//                                                                     .read<
//                                                                         DataProvider>()
//                                                                     .namedevice[
//                                                                         connected[index]
//                                                                             .name]
//                                                                     .toString()),
//                                                                 Text(
//                                                                     "Name : ${connected[index].name}"),
//                                                                 Text(
//                                                                     "Id :  ${connected[index].id}")
//                                                               ],
//                                                             ),
//                                                           ],
//                                                         ),
//                                                       ),
//                                                       actions: [
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(8.0),
//                                                           child:
//                                                               GestureDetector(
//                                                                   onTap: () {
//                                                                     Navigator.pop(
//                                                                         context);

//                                                                     adddevice(
//                                                                         connected[index]
//                                                                             .name,
//                                                                         connected[index]
//                                                                             .id
//                                                                             .toString());
//                                                                   },
//                                                                   child: Text(
//                                                                       'เพิ่ม')),
//                                                         ),
//                                                         Padding(
//                                                           padding:
//                                                               const EdgeInsets
//                                                                   .all(8.0),
//                                                           child:
//                                                               GestureDetector(
//                                                                   onTap: () {
//                                                                     Navigator.pop(
//                                                                         context);
//                                                                   },
//                                                                   child: Text(
//                                                                       'กลับ')),
//                                                         )
//                                                       ]);
//                                                 });
//                                           },
//                                           child: Container(
//                                             width: _width * 0.1,
//                                             child: Icon(
//                                               Icons.add,
//                                               color: Colors.blue,
//                                             ),
//                                           ))
//                                     ],
//                                   ),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         )
//                       : Container();
//                 },
//               ),
//             ),
//           ],
//         ),
//       ]),
//     );
//   }
// }
