import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:smarttelemed/apps/station/background/color/style_color.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';

class scanble extends StatefulWidget {
  const scanble({super.key});

  @override
  State<scanble> createState() => _scanbleState();
}

class _scanbleState extends State<scanble> {
  bool connectionstatus = false;

  Map<String, BluetoothDevice> j = {};
  void connectdevice(ScanResult r) async {
    setState(() {
      connectionstatus = true;
      r.device.connect();
    });
  }

  void initState() {
    //  FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
    //
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: Stack(
        children: [
          backgrund(),
          Positioned(
            child: Container(
              // onRefresh: () => ,
              //  FlutterBluePlus.instance
              //     .startScan(timeout: const Duration(seconds: 4)),
              // child: Container(
              //   child: StreamBuilder<List<ScanResult>>(
              //     stream: FlutterBluePlus.instance.scanResults,
              //     initialData: const [],
              //     builder: (c, snapshot) => SafeArea(
              //       child: ListView(
              //         children: snapshot.data!.map((r) {
              //           if (context
              //               .read<DataProvider>()
              //               .namescan
              //               .contains(r.device.name)) {
              //             return Container(
              //               height: _height * 0.05,
              //               child: Row(
              //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
              //                 children: [
              //                   ElevatedButton(
              //                       onPressed: (() {
              //                         r.device.connect();
              //                       }),
              //                       child: Text('data')),
              //                   Text(r.device.id.toString()),
              //                   Text(r.device.name),
              //                   context
              //                           .read<DataProvider>()
              //                           .deviceId
              //                           .contains(r.device.id.toString())
              //                       ? Container()
              //                       : ElevatedButton(
              //                           style: ButtonStyle(
              //                             backgroundColor: context
              //                                     .read<DataProvider>()
              //                                     .deviceId
              //                                     .contains(
              //                                         r.device.id.toString())
              //                                 ? MaterialStateProperty.all<
              //                                         Color>(
              //                                     Color.fromARGB(0, 0, 0, 0))
              //                                 : MaterialStateProperty.all<
              //                                     Color>(Colors.green),
              //                           ),
              //                           child: const Text('Add'),
              //                           onPressed: () {
              //                             setState(() {
              //                               context
              //                                   .read<DataProvider>()
              //                                   .deviceId
              //                                   .add(r.device.id.toString());
              //                               print(context
              //                                   .read<DataProvider>()
              //                                   .deviceId);
              //                               ScaffoldMessenger.of(context)
              //                                   .showSnackBar(SnackBar(
              //                                       content: Text(
              //                                           'เพิ่มอุปกรณ์ ${r.device.id.toString()}')));
              //                             });
              //                           })
              //                 ],
              //               ),
              //             );
              //           }
              //           return Container();
              //         }).toList(),
              //       ),
              //     ),
              //   ),
              // ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        color: StyleColor.backgroundbegin,
        height: _height * 0.05,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            GestureDetector(
              onTap: () {
                //   FlutterBluePlus.instance.stopScan();
                Navigator.pop(context);
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
    );
  }
}
