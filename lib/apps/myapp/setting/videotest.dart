// import 'package:flutter/material.dart';
// import 'package:logger/logger.dart';
// import 'package:openvidu_client/openvidu_client.dart';
// import 'package:provider/provider.dart';
// import 'package:smart_health/caregiver/videocall/app/models/connection.dart';
// import 'package:smart_health/caregiver/videocall/app/pages/room_page.dart';
// import 'package:smart_health/caregiver/videocall/app/utils/extensions.dart';
// import 'package:smart_health/caregiver/videocall/app/widgets/config_view.dart';
// import 'package:smart_health/caregiver/widget/informationCard.dart';
// import 'package:smart_health/myapp/provider/provider.dart';

// class Test_Video extends StatefulWidget {
//   const Test_Video({super.key});

//   @override
//   State<Test_Video> createState() => _Test_VideoState();
// }

// class _Test_VideoState extends State<Test_Video> {
//   LocalParticipant? localParticipant;
//   late OpenViduClient _openvidu;
//   Map<String, RemoteParticipant> remoteParticipants = {};
//   Future<void> initOpenVidu() async {
//     _openvidu = OpenViduClient('https://openvidu.pcm-life.com');
//     localParticipant =
//         await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
//     setState(() {});
//   }

//   void _listenSessionEvents() {
//     _openvidu.on(OpenViduEvent.userJoined, (params) async {
//       await _openvidu.subscribeRemoteStream(params["id"]);
//     });
//     _openvidu.on(OpenViduEvent.userPublished, (params) {
//       Logger().e("userPublished");

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

//   // Future<void> _onConnect() async {
//   //   Logger().e("start on Connect");
//   //   dynamic connectstring = '';
//   //   print("connectstring เชื่อมต่อ  $connectstring");
//   //   if (true) {
//   //     final connection = Connection.fromJson(connectstring);
//   //     Logger().i(connection.token!);
//   //     localParticipant = await _openvidu.publishLocalStream(
//   //         token: connection.token!, userName: '');
//   //     setState(() {});
//   //   }
//   // }

//   void _onTapDisconnect() async {
//     final nav = Navigator.of(context);
//     final result = await context.showDisconnectDialog();
//     if (result == true) {
//       await _openvidu.disconnect();
//     }
//     Navigator.pop(context);
//   }

//   void test() {}
//   @override
//   void initState() {
//     Logger().d("finish init");

//     initOpenVidu();
//     _listenSessionEvents();
//     // _onConnect();
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;

//     return Scaffold(
//       appBar: AppBar(
//           backgroundColor: Colors.white,
//           iconTheme: IconThemeData(color: Colors.black)),
//       body: localParticipant != null
//           ? Container(
//               height: _height,
//               child: ListView(children: [
//                 Container(height: _height * 0.08),
//                 Container(
//                     child: ConfigView(
//                         participant: localParticipant!, onConnect: test)),
//                 Container(
//                   width: _width,
//                   child: Center(
//                     child: ElevatedButton(
//                         style: ButtonStyle(
//                             backgroundColor:
//                                 MaterialStatePropertyAll(Color(0xff31d6aa))),
//                         onPressed: () {
//                           _onTapDisconnect();
//                         },
//                         child: Text(
//                           'Disconnect',
//                           style: TextStyle(
//                             fontFamily: context.read<DataProvider>().family,
//                             fontSize: 18,
//                           ),
//                         )),
//                   ),
//                 )
//               ]))
//           : Container(),
//     );
//   }
// }
