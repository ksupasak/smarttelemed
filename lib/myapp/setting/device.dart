// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:flutter/src/widgets/framework.dart'; 
// import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:provider/provider.dart';
// import 'package:sembast/sembast.dart';
// import 'package:smarttelemed/myapp/action/playsound.dart';
// import 'package:smarttelemed/myapp/provider/provider.dart'; 
// import 'package:smarttelemed/myapp/setting/local.dart'; 

// class Device extends StatefulWidget {
//   const Device({super.key});

//   @override
//   State<Device> createState() => _DeviceState();
// }

// class _DeviceState extends State<Device> {
//   late List<RecordSnapshot<int, Map<String, Object?>>> init;
//   List<dynamic> deviceList_name = [];
//   List<dynamic> deviceList_id = [];
//   List<MapEntry<String, Object?>>? deviceList;
//   bool refresh = false;

//   Future<void> redipDatabase() async {
//     print('กำลังโหลดDevice');
//     init = await getdevice();
//     for (RecordSnapshot<int, Map<String, Object?>> record in init) {
//       context.read<DataProvider>().mapdevices = record['mapdevices'];
//     }
//     deviceList = context.read<DataProvider>().mapdevices.entries.toList();
//     print(context.read<DataProvider>().mapdevices);
//     print(deviceList);

//     print('โหลดเสร็จเเล้ว');
//     Future.delayed(const Duration(seconds: 1), () {
//       setState(() {
//         deviceList_id = context.read<DataProvider>().mapdevices.values.toList();
//         deviceList_name = context.read<DataProvider>().mapdevices.keys.toList();
//         Future.delayed(const Duration(seconds: 1), () {
//           setState(() {
//             refresh = false;
//             print(deviceList_id);
//             print(deviceList_name);
//           });
//         });
//       });
//     });
//   }

//   void deleteDiver(String name) async {
//     print('กำลังลบdevice $name');
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

//     mapdevices.remove('$name');
//     final key = await store.update(db, {
//       'mapdevices': mapdevices,
//     });
//     redipDatabase();

//     Future.delayed(const Duration(seconds: 5), () {
//       setState(() {
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//             content: Container(
//                 width: MediaQuery.of(context).size.width,
//                 child: Center(
//                     child: Text(
//                   'ลบเสร็จเเล้ว',
//                 )))));
//       });
//     });

//     await db.close();
//   }

//   Future<void> addmapdevices() async {
//     refresh = true;
//     final db = await openDatabasedevice();
//     final store = intMapStoreFactory.store('smart_healt_device');
//     var records = await store.find(db);
//     print(records);

//     if ((records.length == 0)) {
//       Map<String, Object?> mapdevices = {};
//       final key = await store.add(db, {'mapdevices': mapdevices});
//     }
//     redipDatabase();
//     await db.close();
//   }

//   FlutterBluePlus flutterBlue = FlutterBluePlus.instance;
//   void ble_on() async {
//     bool isBluetoothOn = await flutterBlue.isOn;
//     print("isBluetoothOn=${isBluetoothOn}");
//     if (!isBluetoothOn) {
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//           content: Container(
//               width: MediaQuery.of(context).size.width,
//               child: Center(
//                   child: Text(
//                 'กรุณาเปิด Bluetooth',
//               )))));
//     }
//   }

//   @override
//   void initState() {
//     print('เข้าหน้าDevice');
//     ble_on();
//     addmapdevices();

//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     BoxDecoration boxDecoration = BoxDecoration(border: Border.all());
//     return Scaffold(
//       backgroundColor: Colors.white,
//       appBar: AppBar(
//         iconTheme: IconThemeData(color: Colors.black),
//         backgroundColor: Color.fromARGB(255, 255, 255, 255),
//         title: Text(
//           'อุปกรณ์',
//           style: TextStyle(color: Colors.black),
//         ),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 setState(() {
//                   keypad_sound();
//                   addmapdevices();
//                 });
//               },
//               child: refresh == false
//                   ? Icon(
//                       Icons.refresh_sharp,
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
//           Padding(
//             padding: const EdgeInsets.all(8.0),
//             child: GestureDetector(
//               onTap: () {
//                 keypad_sound();
//                 Navigator.push(context,
//                     MaterialPageRoute(builder: (context) => ScanBLE()));
//               },
//               child: Icon(
//                 Icons.add,
//                 color: Colors.black,
//               ),
//             ),
//           ),
//         ],
//       ),
//       body: RefreshIndicator(
//         onRefresh: () async {
//           addmapdevices();
//         },
//         child: SafeArea(
//           child: ListView(
//             children: [
//               Column(
//                 children: deviceList_name
//                     .map((d) => Dismissible(
//                           key: ValueKey(d),
//                           child: Container(
//                             width: _width,
//                             child: Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Container(
//                                 decoration: BoxDecoration(
//                                     borderRadius: BorderRadius.circular(10),
//                                     color: Colors.white,
//                                     boxShadow: [
//                                       BoxShadow(
//                                           color: Colors.black,
//                                           blurRadius: 1,
//                                           offset: Offset(0, 1))
//                                     ]),
//                                 child: Row(
//                                   children: [
//                                     Container(
//                                         height: _height * 0.1,
//                                         width: _height * 0.1,
//                                         child: context
//                                                     .read<DataProvider>()
//                                                     .imagesdevice[d] !=
//                                                 ''
//                                             ? d.toString().length > 15
//                                                 ? 'Yuwell BO-YX110' ==
//                                                         d
//                                                             .toString()
//                                                             .substring(0, 15)
//                                                     ? Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Image.asset(
//                                                             "assets/${context.read<DataProvider>().imagesdevice['Yuwell BO-YX110']}"),
//                                                       )
//                                                     : Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Image.asset(
//                                                             "assets/${context.read<DataProvider>().imagesdevice[d]}"),
//                                                       )
//                                                 : Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Image.asset(
//                                                         "assets/${context.read<DataProvider>().imagesdevice[d]}"),
//                                                   )
//                                             : SizedBox()),
//                                     Column(
//                                       crossAxisAlignment:
//                                           CrossAxisAlignment.start,
//                                       children: [
//                                         context
//                                                     .read<DataProvider>()
//                                                     .namedevice[d] !=
//                                                 null
//                                             ? Text(
//                                                 '${context.read<DataProvider>().namedevice[d]}')
//                                             : Text('เครื่องวัดspo2'),
//                                         Text('Name : ${d}'),
//                                         Text(
//                                             'Id :${context.read<DataProvider>().mapdevices[d]}'),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ),
//                           onDismissed: (direction) {
//                             deleteDiver(d.toString());

//                             ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//                                 content: Container(
//                               child: Center(child: Text('กำลังลบอุปกรณ์ $d')),
//                               width: _width,
//                             )));
//                           },
//                           confirmDismiss: (direction) async {
//                             return await showDialog(
//                               context: context,
//                               builder: (BuildContext context) {
//                                 return AlertDialog(
//                                   title: const Text("Confirm"),
//                                   content: const Text("ยกเลิกการเชื่อมต่อ"),
//                                   actions: <Widget>[
//                                     TextButton(
//                                         onPressed: () =>
//                                             Navigator.of(context).pop(false),
//                                         child: const Text("CANCEL")),
//                                     TextButton(
//                                         onPressed: () =>
//                                             Navigator.of(context).pop(true),
//                                         child: const Text("DELETE"))
//                                   ],
//                                 );
//                               },
//                             );
//                           },
//                           background: Container(color: Colors.white),
//                         ))
//                     .toList(),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
