import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openvidu_flutter/participant/remote_participant.dart';
import 'dart:math' as math; 
import 'package:provider/provider.dart';
import 'package:smarttelemed/openvidu_flutter/app/models/connection.dart';
import 'package:smarttelemed/openvidu_flutter/app/utils/logger.dart';
import 'package:smarttelemed/openvidu_flutter/app/widgets/media_stream_view.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart'; 

class VideoCall extends StatefulWidget {
  const VideoCall({super.key});

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  late OpenViduClient _openvidu;
  Map<String, RemoteParticipant> remoteParticipants = {};
  // LocalParticipant? localParticipant;
  bool isInside = false;
  @override
  void initState() {    
    initOpenVidu();  
    super.initState();
  }

  Future<void> initOpenVidu() async {
    _openvidu = OpenViduClient('https://openvidu.pcm-life.com');
    localParticipant =
        await _openvidu.startLocalPreview(context, StreamMode.frontCamera);
    setState(() {});
      listenSessionEvents();
  }

  void listenSessionEvents() {
    logger.i("finish init");
    _openvidu.on(OpenViduEvent.userJoined, (params) async {
      await _openvidu.subscribeRemoteStream(params["id"]);
    });
    _openvidu.on(OpenViduEvent.userPublished, (params) {
      logger.e("userPublished");

      _openvidu.subscribeRemoteStream(params["id"],
          video: params["videoActive"], audio: params["audioActive"]);
    });

    _openvidu.on(OpenViduEvent.addStream, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.removeStream, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.publishVideo, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.publishAudio, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.updatedLocal, (params) {
      localParticipant = params['localParticipant'];
      setState(() {});
    });
    _openvidu.on(OpenViduEvent.reciveMessage, (params) {
      context.showMessageRecivedDialog(params["data"] ?? '');
    });
    _openvidu.on(OpenViduEvent.userUnpublished, (params) {
      remoteParticipants = {..._openvidu.participants};
      setState(() {});
    });

    _openvidu.on(OpenViduEvent.error, (params) {
      context.showErrorDialog(params["error"]);
    });
  }

  Future<void> onConnect() async {
    dynamic connectstring = context.read<DataProvider>().dataVideoCall;

    if (connectstring != null) {
      logger.i("start on Connect");
      final connection = Connection.fromJson(connectstring);
      logger.i(connection.token!);
      localParticipant = await _openvidu.publishLocalStream(
          token: connection.token!, userName: "userName");
      setState(() {
        isInside = true;
      });
    }
  }

  @override
  void dispose() async {
    await localParticipant!.close();
    await _openvidu.disconnect();
    setState(() {
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Stack(
      children: [
        const backgrund(),
        Positioned(
          child: !isInside
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    BoxTime(),
                    BoxDecorate(
                        child: InformationCard(
                            dataidcard:
                                context.read<DataProvider>().dataidcard)),
                    SizedBox(
                      height: height * 0.06,
                      width: width,
                      child: Center(
                        child: Text(
                          'เตรียมความพร้อม',
                          style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff48B5AA)),
                        ),
                      ),
                    ),
                    localParticipant != null
                        ? SizedBox(
                            width: width * 0.9,
                            child: ConfigView(
                                participant: localParticipant!,
                                onConnect: onConnect))
                        : const SizedBox(),

                        
                    ElevatedButton(
                        onPressed: () {
                            localParticipant!.close();
                          _openvidu.disconnect();
                          setState(() { 
                          });
                        Get.offNamed('user_information');
                        },
                        child: const Text("ออก")),
                  ],
                )
              : SizedBox(
                  child: Stack(
                    children: [
                      ListView.builder(
                          itemCount: math.max(0, remoteParticipants.length),
                          itemBuilder: (BuildContext context, int index) {
                            final remote =
                                remoteParticipants.values.elementAt(index);
                            return SizedBox(
                              width: width /
                                  math.max(1, remoteParticipants.length),
                              height: height /
                                  math.max(1, remoteParticipants.length),
                              child: Expanded(
                                child: MediaStreamView(
                                  borderRadius: BorderRadius.circular(5),
                                  participant: remote,
                                ),
                              ),
                            );
                          }),
                      Positioned(
                          child: ElevatedButton(
                        onPressed: ()   {
                            _openvidu.disconnect();
                          setState(() { 
                          });
                      Get.offNamed('user_information');
                        },
                        child: const Text("ออก"),
                      )),
                      Positioned(
                        bottom: 5,
                        left: 5,
                        child: SizedBox(
                          height: height * 0.25,
                          width: width * 0.3,
                          child: MediaStreamView(
                            borderRadius: BorderRadius.circular(5),
                            participant: localParticipant!,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      ],
    ));
  }
}
