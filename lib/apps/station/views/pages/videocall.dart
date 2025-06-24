// // ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names

// import 'dart:async';
// import 'dart:convert';
// import 'dart:math' as math;
// import 'dart:math';
// import 'package:flutter/foundation.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:dio/dio.dart';
// import 'package:flutter/material.dart';
 
// import 'package:provider/provider.dart';
// import 'package:smarttelemed/station/app/models/connection.dart';
// import 'package:smarttelemed/station/app/utils/extensions.dart';
// import 'package:smarttelemed/station/app/utils/logger.dart';
// import 'package:smarttelemed/station/app/widgets/config_view.dart';
// import 'package:smarttelemed/station/app/widgets/controls.dart';
// import 'package:smarttelemed/station/app/widgets/media_stream_view.dart';
// import 'package:smarttelemed/station/background/background.dart';
// import 'package:smarttelemed/station/background/color/style_color.dart';

// import 'package:smarttelemed/station/provider/provider.dart';
// import 'package:smarttelemed/station/views/pages/user_information2.dart';
// import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

// class PrePareVideo extends StatefulWidget {
//   const PrePareVideo({super.key});

//   @override
//   State<PrePareVideo> createState() => _PrePareVideoState();
// }

// class _PrePareVideoState extends State<PrePareVideo> {
//   var data;
//   var resTojson;
//   String? status;
//   @override
//   void initState() {
//     get_path_video();
//     super.initState();
//   }

//   Future<void> get_path_video() async {
//     var url =
//         Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
//     var res = await http
//         .post(url, body: {'public_id': context.read<DataProvider>().id});
//     resTojson = json.decode(res.body);
//     setState(() {
//       data = resTojson['data'];
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return resTojson != null
//         ? resTojson['data'][0] == null
//             ? SizedBox(
//                 height: height * 0.7,
//                 child: Center(
//                   child: RoomPage(
//                     userName: ' UserName ',
//                     data: data,
//                   ),
//                 ),
//               )
//             : Container()
//         : Scaffold(
//             body: Stack(
//               children: [
//                 Positioned(
//                     child: SizedBox(
//                   height: height,
//                   width: width,
//                   child: SvgPicture.asset(
//                     'assets/login.svg',
//                     fit: BoxFit.fill,
//                   ),
//                 )),
//                 Positioned(
//                   child: SizedBox(
//                     height: height,
//                     width: width,
//                     child: Center(
//                       child: SizedBox(
//                         height: height * 0.06,
//                         width: width,
//                         child: Center(
//                           child: Text(
//                             'กำลังเชื่อมต่อวีดีโอ',
//                             style: TextStyle(
//                               fontSize: width * 0.05,
//                               fontWeight: FontWeight.w500,
//                               fontFamily:
//                                   context.read<DataProvider>().fontFamily,
//                               color: const Color(0xff00A3FF),
//                               shadows: const [
//                                 Shadow(
//                                   color: Colors.grey,
//                                   offset: Offset(2, 2),
//                                   blurRadius: 4,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                 )
//               ],
//             ),
//           );
//   }
// }

// class RoomPage extends StatefulWidget {
//   final String userName;
//   var data;
//   RoomPage({
//     super.key,
//     required this.userName,
//     this.data,
//   });
//   @override
//   State<RoomPage> createState() => _RoomPageState();
// }

// class _RoomPageState extends State<RoomPage> {
//   Map<String, RemoteParticipant> remoteParticipants = {};
//   MediaDeviceInfo? input;
//   bool isInside = false;
//   late OpenViduClient _openvidu;
//   var resTojson;
//   var resTojson2;
//   String? status;
//   LocalParticipant? localParticipant;

//   Timer? _timer;

//   void initState() {
//     super.initState();
//     initOpenVidu();
//     _listenSessionEvents();
//     logger.e("finish init");
//     _onConnect();
//     lop();
//   }

//   void _listenSessionEvents() {
//     _openvidu.on(OpenViduEvent.userJoined, (params) async {
//       await _openvidu.subscribeRemoteStream(params["id"]);
//     });
//     _openvidu.on(OpenViduEvent.userPublished, (params) {
//       logger.e("userPublished");

//       _openvidu.subscribeRemoteStream(params["id"],
//           video: params["videoActive"], audio: params["audioActive"]);
//     });

//     _openvidu.on(OpenViduEvent.addStream, (params) {
//       remoteParticipants = {..._openvidu.participants};
//       setState(() {});
//     });

//     _openvidu.on(OpenViduEvent.removeStream, (params) {
//       remoteParticipants = {..._openvidu.participants};
//       setState(() {});
//     });

//     _openvidu.on(OpenViduEvent.publishVideo, (params) {
//       remoteParticipants = {..._openvidu.participants};
//       setState(() {});
//     });
//     _openvidu.on(OpenViduEvent.publishAudio, (params) {
//       remoteParticipants = {..._openvidu.participants};
//       setState(() {});
//     });
//     _openvidu.on(OpenViduEvent.updatedLocal, (params) {
//       localParticipant = params['localParticipant'];
//       setState(() {});
//     });
//     _openvidu.on(OpenViduEvent.reciveMessage, (params) {
//       context.showMessageRecivedDialog(params["data"] ?? '');
//     });
//     _openvidu.on(OpenViduEvent.userUnpublished, (params) {
//       remoteParticipants = {..._openvidu.participants};
//       setState(() {});
//     });

//     _openvidu.on(OpenViduEvent.error, (params) {
//       context.showErrorDialog(params["error"]);
//     });
//   }

//   Future<void> initOpenVidu() async {
//     _openvidu = OpenViduClient('https://openvidu.pcm-life.com');
//     localParticipant =
//         await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
//     setState(() {});
//   }

//   Future<void> _onConnect() async {
//     logger.e("start on Connect");
//     dynamic connectstring = widget.data;

//     if (true) {
//       final connection = Connection.fromJson(connectstring);
//       logger.i(connection.token!);
//       localParticipant = await _openvidu.publishLocalStream(
//           token: connection.token!, userName: widget.userName);
//       setState(() {
//         isInside = true;
//       });
//     }
//   }

//   void _onTapDisconnect() async {
//     final result = await context.showDisconnectDialog();
//     if (result == true) {
//       await _openvidu.disconnect();
//       _timer?.cancel();
//     }
//   }

//   Future<void> status_video() async {
//     var url = Uri.parse(
//         '${context.read<DataProvider>().platfromURL}/get_video_status');
//     var res = await http
//         .post(url, body: {'public_id': context.read<DataProvider>().id});
//     resTojson2 = json.decode(res.body);
//     if (resTojson2 != null) {
//       status = resTojson2['message'];
//       if (status == 'completed' || status == 'finished' || status == 'end') {
//         print('คุยเสร็จเเล้ว');
//         _timer?.cancel();
//         await _openvidu.disconnect();
//         Navigator.pushReplacement(context,
//             MaterialPageRoute(builder: (context) => const UserInformation()));
//       } else {
//         print('คุยยังไม่เสร็จ : startus $status');
//       }
//     }
//   }

//   void lop() {
//     _timer = Timer.periodic(const Duration(seconds: 4), (timer) {
//       status_video();
//     });
//   }

//   @override
//   void dispose() async {
//     _timer?.cancel();
//     await _openvidu.disconnect();

//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     return SafeArea(
//       child: Scaffold(
//         body: Stack(children: [
//           backgrund(),
//           Positioned(
//             child: localParticipant == null
//                 ? Container()
//                 : !isInside
//                     ? Container(
//                         child: Column(
//                             crossAxisAlignment: CrossAxisAlignment.center,
//                             mainAxisAlignment: MainAxisAlignment.start,
//                             children: [
//                             BoxTime(),
//                             BoxDecorate(
//                                 child: InformationCard(
//                                     dataidcard: context
//                                         .read<DataProvider>()
//                                         .dataidcard)),
//                             Container(
//                               height: _height * 0.06,
//                               width: _width,
//                               child: Center(
//                                 child: Text(
//                                   'เตรียมความพร้อม',
//                                   style: TextStyle(
//                                       fontSize: _width * 0.05,
//                                       fontWeight: FontWeight.w500,
//                                       fontFamily: context
//                                           .read<DataProvider>()
//                                           .fontFamily,
//                                       color: const Color(0xff48B5AA)),
//                                 ),
//                               ),
//                             ),
//                             Container(
//                                 width: _width * 0.9,
//                                 child: ConfigView(
//                                     participant: localParticipant!,
//                                     onConnect: _onConnect))
//                           ]))
//                     : Container(
//                         child: Stack(children: [
//                           Positioned(
//                             child: ListView.builder(
//                                 itemCount:
//                                     math.max(0, remoteParticipants.length),
//                                 itemBuilder: (BuildContext context, int index) {
//                                   final remote = remoteParticipants.values
//                                       .elementAt(index);
//                                   return SizedBox(
//                                     width: _width /
//                                         math.max(1, remoteParticipants.length),
//                                     height: _height /
//                                         math.max(1, remoteParticipants.length),
//                                     child: Expanded(
//                                       child: MediaStreamView(
//                                         borderRadius: BorderRadius.circular(5),
//                                         participant: remote,
//                                       ),
//                                     ),
//                                   );
//                                 }),
//                           ),
//                           Positioned(
//                             bottom: -10,
//                             child: SizedBox(
//                               height: _height * 0.07,
//                               width: _width,
//                               child: Row(
//                                 mainAxisAlignment: MainAxisAlignment.end,
//                                 children: [
//                                   GestureDetector(
//                                     onTap: () {
//                                       _onTapDisconnect();
//                                     },
//                                     child: Image.asset('assets/skrhjk.png'),
//                                   ),
//                                   GestureDetector(
//                                     onTap: () {
//                                       onTap:
//                                       showModalBottomSheet(
//                                           backgroundColor: const Color.fromARGB(
//                                               255, 255, 255, 255),
//                                           isScrollControlled: true,
//                                           shape: const RoundedRectangleBorder(
//                                               borderRadius:
//                                                   BorderRadius.vertical(
//                                                       top:
//                                                           Radius.circular(10))),
//                                           context: context,
//                                           builder: (context) => ControlsWidget(
//                                               _openvidu, localParticipant!));
//                                     },
//                                     child: Image.asset('assets/gjdz.png'),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           ),
//                           Positioned(
//                             bottom: 5,
//                             left: 5,
//                             child: SizedBox(
//                               height: _height * 0.25,
//                               width: _width * 0.3,
//                               child: MediaStreamView(
//                                 borderRadius: BorderRadius.circular(5),
//                                 participant: localParticipant!,
//                               ),
//                             ),
//                           ),
//                         ]),
//                       ),
//           )
//         ]),
//         bottomNavigationBar: !isInside
//             ? SizedBox(
//                 height: _height * 0.03,
//                 child: Row(
//                   children: [
//                     Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: GestureDetector(
//                         onTap: () {
//                           _timer?.cancel();
//                           setState(() {});
//                         },
//                         child: Container(
//                           height: _height * 0.025,
//                           width: _width * 0.15,
//                           decoration: BoxDecoration(
//                               borderRadius: BorderRadius.circular(10),
//                               border: Border.all(
//                                   color:
//                                       const Color.fromARGB(255, 201, 201, 201),
//                                   width: _width * 0.002)),
//                           child: Center(
//                               child: Text(
//                             '< ย้อนกลับ',
//                             style: TextStyle(
//                                 fontFamily:
//                                     context.read<DataProvider>().fontFamily,
//                                 fontSize: _width * 0.03,
//                                 color:
//                                     const Color.fromARGB(255, 201, 201, 201)),
//                           )),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               )
//             : null,
//       ),
//     );
//   }
// }

// class ConnectPage extends StatefulWidget {
//   ConnectPage({
//     super.key,
//   });

//   @override
//   State<ConnectPage> createState() => _ConnectPageState();
// }

// class _ConnectPageState extends State<ConnectPage> {
//   final bool _busy = false;
//   var data;
//   final TextEditingController _textUserNameController = TextEditingController();

//   final Dio _dio = Dio();

//   _connect(BuildContext ctx) async {
//     await Navigator.pushReplacement(
//         context,
//         MaterialPageRoute(
//             builder: (context) => RoomPage(
//                   userName: _textUserNameController.text,
//                   data: data,
//                 )));
//   }

//   Future<void> get_path_video() async {
//     var url =
//         Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
//     var res = await http
//         .post(url, body: {'public_id': context.read<DataProvider>().id});
//     var resTojson = json.decode(res.body);
//     data = resTojson['data'];
//     if (data != null) {
//       Timer(const Duration(seconds: 1), () {
//         setState(() {
//           _connect(context);
//         });
//       });
//     }
//   }

//   @override
//   void initState() {
//     super.initState();

//     _textUserNameController.text = 'Participante${Random().nextInt(1000)}';
//     get_path_video();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double width = MediaQuery.of(context).size.width;
//     double height = MediaQuery.of(context).size.height;
//     return Scaffold(
//         body: Stack(
//       children: [
//         Positioned(
//             child: BackGroundSmart_Health(
//           BackGroundColor: const [
//             StyleColor.backgroundbegin,
//             StyleColor.backgroundend
//           ],
//         )),
//         Positioned(
//           child: SizedBox(
//             width: width,
//             height: height,
//             child: Center(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   const Text('กำลังโหลด'),
//                   SizedBox(
//                       width: width * 0.2,
//                       height: width * 0.2,
//                       child: const CircularProgressIndicator()),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ],
//     ));
//   }
// }
