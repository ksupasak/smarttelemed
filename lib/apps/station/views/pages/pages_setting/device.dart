import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smarttelemed/apps/station/background/color/style_color.dart';
import 'package:smarttelemed/apps/station/local/local.dart';
import 'package:smarttelemed/apps/station/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/pages/pages_setting/functionble/scan.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';

class Device extends StatefulWidget {
  const Device({super.key});

  @override
  State<Device> createState() => _DeviceState();
}

class _DeviceState extends State<Device> {
  var device;
  List<BluetoothDevice> j = [];
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return RefreshIndicator(
      onRefresh: () async {
        setState(() {});
      },
      child: Scaffold(
        body: Stack(
          children: [
            backgrund(),

            // Positioned(
            //   child: SafeArea(
            //     child: SingleChildScrollView(
            //       child: Column(
            //         children: <Widget>[
            //           StreamBuilder<List<BluetoothDevice>>(
            //             stream: Stream.periodic(const Duration(seconds: 2))
            //                 .asyncMap((_) =>
            //                     FlutterBluePlus.instance.connectedDevices),
            //             initialData: const [],
            //             builder: (c, snapshot) => Column(
            //               children: snapshot.data!.map((d) {
            //                 //ถ่าไม่มีในรายการไห้ยกเลิกเชื่อมต่อ
            //                 return Container();
            //                 // ListTile(
            //                 //   title: Text(d.name),
            //                 //   trailing: StreamBuilder<BluetoothDeviceState>(
            //                 //     stream: d.state,
            //                 //     initialData: BluetoothDeviceState.disconnected,
            //                 //     builder: (c, snapshot) {
            //                 //       if (snapshot.data ==
            //                 //           BluetoothDeviceState.connected) {
            //                 //         return Text(snapshot.data.toString());
            //                 //       }
            //                 //       return Text(snapshot.data.toString());
            //                 //     },
            //                 //   ),
            //                 // );
            //               }).toList(),
            //             ),
            //           ),
            //           Column(
            //             children: context
            //                 .read<DataProvider>()
            //                 .deviceId
            //                 .map((d) => Dismissible(
            //                       key: ValueKey(d),
            //                       child: Container(
            //                         height: 50,
            //                         width: _width,
            //                         color: Colors.green,
            //                         child: Column(
            //                           children: [
            //                             Text(d),
            //                           ],
            //                         ),
            //                       ),
            //                       onDismissed: (direction) {
            //                         setState(() {
            //                           context
            //                               .read<DataProvider>()
            //                               .deviceId
            //                               .remove(d);
            //                           print(context
            //                               .read<DataProvider>()
            //                               .deviceId);
            //                         });
            //                         ScaffoldMessenger.of(context).showSnackBar(
            //                             SnackBar(
            //                                 content: Text('ลบอุปกรณ์ $d')));
            //                       },
            //                       confirmDismiss: (direction) async {
            //                         return await showDialog(
            //                           context: context,
            //                           builder: (BuildContext context) {
            //                             return AlertDialog(
            //                               title: const Text("Confirm"),
            //                               content:
            //                                   const Text("ยกเลิกการเชื่อมต่อ"),
            //                               actions: <Widget>[
            //                                 TextButton(
            //                                     onPressed: () =>
            //                                         Navigator.of(context)
            //                                             .pop(false),
            //                                     child: const Text("CANCEL")),
            //                                 TextButton(
            //                                     onPressed: () =>
            //                                         Navigator.of(context)
            //                                             .pop(true),
            //                                     child: const Text("DELETE"))
            //                               ],
            //                             );
            //                           },
            //                         );
            //                       },
            //                       background: Container(color: Colors.red),
            //                     ))
            //                 .toList(),
            //           ),
            //         ],
            //       ),
            //     ),
            //   ),
            // )
          ],
        ),
        bottomNavigationBar: Container(
          color: StyleColor.backgroundbegin,
          height: _height * 0.05,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  addDataInfoToDatabase(DataProvider());
                },
                child: BoxWidetdew(
                  color: Color.fromARGB(0, 255, 255, 255),
                  width: 0.2,
                  height: 0.15,
                  radius: 0.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: ((context) => scanble())),
                  );
                },
                child: BoxWidetdew(
                  color: Colors.blue,
                  text: '+',
                  textcolor: Colors.white,
                  fontSize: 0.05,
                  width: 0.2,
                  height: 0.15,
                  radius: 0.0,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                  addDataInfoToDatabase(DataProvider());
                },
                child: BoxWidetdew(
                  color: Colors.red,
                  text: 'ออก',
                  textcolor: Colors.white,
                  fontSize: 0.05,
                  width: 0.2,
                  height: 0.15,
                  radius: 0.0,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
