import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/pages/pages_setting/device.dart';
import 'package:smarttelemed/station/views/pages/pages_setting/functionble/scan.dart';

// class _FindDevicesScreenState extends State<Device> {
//   @override
//   void initState() {
//     FlutterBluePlus.instance.startScan(timeout: const Duration(seconds: 4));
//     FlutterBluePlus.instance.stopScan();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: RefreshIndicator(
//           onRefresh: () => FlutterBluePlus.instance
//               .startScan(timeout: const Duration(seconds: 4)),
//           child: SingleChildScrollView(
//             child: Column(
//               children: <Widget>[
//                 StreamBuilder<List<BluetoothDevice>>(
//                   stream: Stream.periodic(const Duration(seconds: 2)).asyncMap(
//                       (_) => FlutterBluePlus.instance.connectedDevices),
//                   initialData: const [],
//                   builder: (c, snapshot) => Column(
//                     children: snapshot.data!.map((d) {
//                       // if (!context
//                       //     .read<DataProvider>()
//                       //     .knownDevice
//                       //     .contains(d)) {
//                       //   context.read<DataProvider>().knownDevice.add(d.name);
//                       // }
//                       return ListTile(
//                         trailing: StreamBuilder<BluetoothDeviceState>(
//                           stream: d.state,
//                           initialData: BluetoothDeviceState.disconnected,
//                           builder: (c, snapshot) {
//                             return Text(snapshot.data.toString());
//                           },
//                         ),
//                       );
//                     }).toList(),
//                   ),
//                 ),
//                 // StreamBuilder<List<BluetoothDevice>>(
//                 //   stream: Stream.periodic(const Duration(seconds: 2)).asyncMap(
//                 //       (_) => FlutterBluePlus.instance.connectedDevices),
//                 //   initialData: const [],
//                 //   builder: (c, snapshot) => Column(
//                 //     children: context
//                 //         .read<DataProvider>()
//                 //         .knownDevice
//                 //         .map((d) => Container(
//                 //               height: 50,
//                 //               color: Colors.amber,
//                 //               child: Column(
//                 //                 children: [
//                 //                   Text(d.toString()),
//                 //                 ],
//                 //               ),
//                 //             ))
//                 //         .toList(),
//                 //   ),
//                 // ),
//               ],
//             ),
//           ),
//         ),
//       ),
//       bottomNavigationBar: Container(
//           height: 50,
//           child: Center(
//               child: Container(
//                   height: 50,
//                   width: 100,
//                   color: Colors.green,
//                   child: Center(child: Text('สลับหน้า'))))),
//     );
//   }
// }

// class ServiceTile extends StatelessWidget {
//   final BluetoothService service;
//   final List<CharacteristicTile> characteristicTiles;

//   const ServiceTile(
//       {Key? key, required this.service, required this.characteristicTiles})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     if (characteristicTiles.isNotEmpty) {
//       return ExpansionTile(
//         title: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: <Widget>[
//             const Text('Service'),
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}',
//                 style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                     color: Theme.of(context).textTheme.caption?.color))
//           ],
//         ),
//         children: characteristicTiles,
//       );
//     } else {
//       return ListTile(
//         title: const Text('Service'),
//         subtitle:
//             Text('0x${service.uuid.toString().toUpperCase().substring(4, 8)}'),
//       );
//     }
//   }
// }

// class CharacteristicTile extends StatefulWidget {
//   final BluetoothCharacteristic characteristic;
//   final List<DescriptorTile> descriptorTiles;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;
//   final VoidCallback? onNotificationPressed;

//   const CharacteristicTile(
//       {Key? key,
//       required this.characteristic,
//       required this.descriptorTiles,
//       this.onReadPressed,
//       this.onWritePressed,
//       this.onNotificationPressed})
//       : super(key: key);

//   @override
//   State<CharacteristicTile> createState() => _CharacteristicTileState();
// }

// class _CharacteristicTileState extends State<CharacteristicTile> {
//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<List<int>>(
//       stream: widget.characteristic.value,
//       initialData: widget.characteristic.lastValue,
//       builder: (c, snapshot) {
//         final value = snapshot.data;

//         return ExpansionTile(
//           backgroundColor: Colors.amber,
//           title: ListTile(
//             title: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: <Widget>[
//                 const Text('CharacteristicEIEI'),
//                 Text('${c}'),
//                 Text('${snapshot.data}'), //ตรงนี้
//                 Text('${widget.characteristic.lastValue}'),
//                 Text('${widget.characteristic.lastValue}'),
//                 Text('updew-${widget.characteristic.isNotifying}'),
//                 Text('pp-${widget.characteristic.value}'),
//                 Text(
//                     '0x${widget.characteristic.uuid.toString().toUpperCase().substring(4, 8)}',
//                     style: Theme.of(context).textTheme.bodyText1?.copyWith(
//                         color: Theme.of(context).textTheme.caption?.color)),
//               ],
//             ),
//             subtitle: Column(
//               children: [
//                 Text('ตรงนี้'),
//                 Text(value.toString()),
//               ],
//             ),
//             contentPadding: const EdgeInsets.all(0.0),
//           ),
//           trailing: Row(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               IconButton(
//                 icon: Icon(
//                   Icons.file_download,
//                   color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//                 ),
//                 onPressed: widget.onReadPressed,
//               ),
//               IconButton(
//                 icon: Icon(Icons.file_upload,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: widget.onWritePressed,
//               ),
//               IconButton(
//                 icon: Icon(
//                     widget.characteristic.isNotifying
//                         ? Icons.home
//                         //Icons.sync_disabled
//                         : Icons.sync,
//                     color: Theme.of(context).iconTheme.color?.withOpacity(0.5)),
//                 onPressed: widget.onNotificationPressed,
//               )
//             ],
//           ),
//           children: widget.descriptorTiles,
//         );
//       },
//     );
//   }
// }

// class DescriptorTile extends StatelessWidget {
//   final BluetoothDescriptor descriptor;
//   final VoidCallback? onReadPressed;
//   final VoidCallback? onWritePressed;

//   const DescriptorTile(
//       {Key? key,
//       required this.descriptor,
//       this.onReadPressed,
//       this.onWritePressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return ListTile(
//       title: Column(
//         mainAxisAlignment: MainAxisAlignment.center,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           const Text('Descriptor'),
//           Text('0x${descriptor.uuid.toString().toUpperCase().substring(4, 8)}',
//               style: Theme.of(context)
//                   .textTheme
//                   .bodyText1
//                   ?.copyWith(color: Theme.of(context).textTheme.caption?.color))
//         ],
//       ),
//       subtitle: StreamBuilder<List<int>>(
//         stream: descriptor.value,
//         initialData: descriptor.lastValue,
//         builder: (c, snapshot) => Text(snapshot.data.toString()),
//       ),
//       trailing: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: <Widget>[
//           IconButton(
//             icon: Icon(
//               Icons.file_download,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onReadPressed,
//           ),
//           IconButton(
//             icon: Icon(
//               Icons.file_upload,
//               color: Theme.of(context).iconTheme.color?.withOpacity(0.5),
//             ),
//             onPressed: onWritePressed,
//           )
//         ],
//       ),
//     );
//   }
// }

// class ScanResultTile extends StatelessWidget {
//   const ScanResultTile({Key? key, required this.result, this.onTap})
//       : super(key: key);

//   final ScanResult result;
//   final VoidCallback? onTap;

//   Widget _buildTitle(BuildContext context) {
//     if (result.device.name.isNotEmpty) {
//       return Column(
//         mainAxisAlignment: MainAxisAlignment.start,
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Text(
//             result.device.name,
//             overflow: TextOverflow.ellipsis,
//           ),
//           Text(
//             result.device.id.toString(),
//             style: Theme.of(context).textTheme.caption,
//           )
//         ],
//       );
//     } else {
//       return Text(result.device.id.toString());
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ExpansionTile(
//       title: _buildTitle(context),
//       leading: Text(result.rssi.toString()),
//       trailing: ElevatedButton(
//         child: const Text('CONNECT'),
//         style: ElevatedButton.styleFrom(
//           primary: Colors.black,
//           onPrimary: Colors.white,
//         ),
//         onPressed: (result.advertisementData.connectable) ? onTap : null,
//       ),
//     );
//   }
// }
