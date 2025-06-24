import 'dart:convert';
import 'dart:math';
import 'dart:io';
import 'dart:async';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logging/logging.dart';
import 'package:smarttelemed/openvidu_flutter/screens/videocall.dart';
import 'package:smarttelemed/apps/station/main_app/app.dart';
import 'package:smarttelemed/apps/station/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';

class PrepareVideocall extends StatefulWidget {
  const PrepareVideocall({super.key});

  @override
  State<PrepareVideocall> createState() => _PrepareVideocallState();
}

class _PrepareVideocallState extends State<PrepareVideocall> {
  final Logger _logger = Logger('PrepareVideocall');

  bool isOnline = false;
  late TextEditingController _textSessionController;
  late TextEditingController _textUserNameController;
  late TextEditingController _textUrlController;
  late TextEditingController _textSecretController;
  late TextEditingController _textPortController;
  late TextEditingController _textIceServersController;
  var resToJsonVideo;
  @override
  void initState() {
    super.initState();

    _textSessionController = TextEditingController(
      text: 'session-flutter-${Random().nextInt(1000)}',
    );
    _textUserNameController = TextEditingController(
      text: 'FlutterUser${Random().nextInt(1000)}',
    );
    _textUrlController = TextEditingController(text: 'demos.openvidu.io');
    _textSecretController = TextEditingController(text: 'MY_SECRET');
    _textPortController = TextEditingController(text: '443');
    _textIceServersController = TextEditingController(
      text: 'stun.l.google.com:19302',
    );

    _loadSharedPref();
    _liveConn();
    getvideocalldata();
  }

  Future<void> getvideocalldata() async {
    var url = Uri.parse(
      '${context.read<DataProvider>().platfromURL}/get_video',
    );
    var res = await http.post(
      url,
      body: {'public_id': context.read<DataProvider>().id},
    );
    resToJsonVideo = json.decode(res.body);
    setState(() {});
    debugPrint(
      "id :${context.read<DataProvider>().id} /get video :${resToJsonVideo.toString()} ",
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) {
          _saveSharedPref();
          return VideocallWidget(
            server: 'openvidu.pcm-life.com',
            sessionId: resToJsonVideo["data"]["sessionId"],
            token: resToJsonVideo["data"]["token"],
            userName: "People",
            secret: "minadadmin",
            iceServer: "",
          );
        },
      ),
    );
  }

  Future<void> _loadSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _textUrlController.text =
        prefs.getString('textUrl') ?? _textUrlController.text;
    _textSecretController.text =
        prefs.getString('textSecret') ?? _textSecretController.text;
    _textPortController.text =
        prefs.getString('textPort') ?? _textPortController.text;
    _textIceServersController.text =
        prefs.getString('textIceServers') ?? _textIceServersController.text;
  }

  Future<void> _saveSharedPref() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('textUrl', _textUrlController.text);
    await prefs.setString('textSecret', _textSecretController.text);
    await prefs.setString('textPort', _textPortController.text);
    await prefs.setString('textIceServers', _textIceServersController.text);
  }

  Future<void> _liveConn() async {
    await _checkOnline();
    Timer.periodic(const Duration(seconds: 5), (timer) async {
      await _checkOnline();
    });
  }

  Future<void> _checkOnline() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        if (!isOnline) {
          isOnline = true;
          setState(() {});
          _logger.info('Online..');
        }
      }
    } on SocketException catch (_) {
      if (isOnline) {
        isOnline = false;
        setState(() {});
        _logger.info('..Offline');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            child: Center(
              child: SizedBox(
                width: width,
                height: height,
                child: SizedBox(
                  height: height * 0.2,
                  width: width,
                  child: SvgPicture.asset(
                    'assets/splash.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            child: SizedBox(
              height: height,
              width: width,
              child: Center(
                child: SizedBox(
                  height: height,
                  width: width,
                  child: Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          'DOWNLOAD DATA VIDEO',
                          style: TextStyle(
                            fontSize: width * 0.05,
                            fontWeight: FontWeight.w500,
                            color: const Color.fromARGB(255, 0, 139, 130),
                            shadows: const [
                              Shadow(
                                color: Colors.grey,
                                offset: Offset(2, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: height * 0.05),
                        const CircularProgressIndicator(
                          color: Color.fromARGB(255, 0, 139, 130),
                        ),
                        SizedBox(height: height * 0.05),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );

    // SingleChildScrollView(
    //   padding: const EdgeInsets.all(10.0),
    //   child: Center(
    //     child: Column(
    //       mainAxisAlignment: MainAxisAlignment.center,
    //       crossAxisAlignment: CrossAxisAlignment.center,
    //       children: <Widget>[
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _textSessionController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'Session name',
    //               hintText: 'Enter session name'),
    //         ),
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _textUserNameController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'Session username',
    //               hintText: 'Enter username'),
    //         ),
    //         const SizedBox(height: 40),
    //         TextField(
    //           controller: _textUrlController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'OpenVidu server url',
    //               hintText: 'Enter OpenVidu server url'),
    //         ),
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _textPortController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'OpenVidu server port',
    //               hintText: 'Enter OpenVidu server port'),
    //         ),
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _textSecretController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'OpenVidu server secret',
    //               hintText: 'Enter OpenVidu server secret'),
    //         ),
    //         const SizedBox(height: 10),
    //         TextField(
    //           controller: _textIceServersController,
    //           decoration: const InputDecoration(
    //               contentPadding: EdgeInsets.all(5),
    //               border: OutlineInputBorder(),
    //               labelText: 'Ice server',
    //               hintText: 'Enter ice server url'),
    //         ),
    //         const SizedBox(
    //           height: 30,
    //         ),
    //         CupertinoButton(
    //           padding: const EdgeInsets.all(15.0),
    //           color: Colors.green[400],
    //           disabledColor: Colors.grey,
    //           onPressed: isOnline
    //               ? () => Navigator.pushReplacement(context,
    //                       MaterialPageRoute(builder: (context) {
    //                     _saveSharedPref();
    //                     return VideocallWidget(
    //                       server:
    //                           '${_textUrlController.text}:${_textPortController.text}',
    //                       sessionId: _textSessionController.text,
    //                       token: "",
    //                       userName: _textUserNameController.text,
    //                       secret: _textSecretController.text,
    //                       iceServer: _textIceServersController.text,
    //                     );
    //                   }))
    //               : null,
    //           child: Text(
    //             isOnline ? 'Join' : 'Offline',
    //             style: const TextStyle(fontSize: 20.0),
    //           ),
    //         ),
    //         ElevatedButton(
    //             onPressed: () {
    //               Get.offNamed('user_information');
    //             },
    //             child: Text("<-"))
    //       ],
    //     ),
    //   ),
    // ),
  }
}
