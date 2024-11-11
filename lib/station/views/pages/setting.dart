// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/container.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:get/get.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_health/station/background/background.dart';
// import 'package:smart_health/station/background/color/style_color.dart';
// import 'package:smart_health/station/provider/provider_function.dart';
// import 'package:smart_health/station/views/ui/widgetdew.dart/widgetdew.dart';

// class Setting extends StatefulWidget {
//   const Setting({super.key});

//   @override
//   State<Setting> createState() => _SettingState();
// }

// class _SettingState extends State<Setting> {
//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     return Scaffold(
//       body: SafeArea(
//         child: GestureDetector(
//           onTap: (() {
//             FocusScope.of(context).requestFocus(FocusNode());
//           }),
//           child: Stack(
//             children: [
//               backgrund(),
//               Positioned(
//                 child: Container(
//                   width: _width,
//                   child: Column(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       GestureDetector(
//                           onTap: () {
//                             context.read<Datafunction>().playsound();
//                             Get.toNamed('initsetting');
//                           },
//                           child: BoxSetting(text: 'Initsetting')),
//                       GestureDetector(
//                           onTap: () {
//                             context.read<Datafunction>().playsound();
//                             Get.toNamed('device');
//                           },
//                           child: BoxSetting(text: 'Device')),
//                       GestureDetector(
//                           onTap: () {
//                             context.read<Datafunction>().playsound();
//                             Get.offNamed('home');
//                           },
//                           child: BoxSetting(text: 'Exit')),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
