import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:media_kit_libs_video/media_kit_libs_video.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:audioplayers/audioplayers.dart';

class PatientAppointment extends StatefulWidget {
  const PatientAppointment({Key? key}) : super(key: key);
  @override
  State<PatientAppointment> createState() => PatientAppointmentState();
}

class PatientAppointmentState extends State<PatientAppointment> {
  // Create a [Player] to control playback.
  late final player = Player();
  // Create a [VideoController] to handle video output from [Player].
  late final controller = VideoController(player);
  late final WebviewController web_controller;

  bool _isPlaying = false;

  bool _isReady = false;
  bool _isLoading = true;

  // final FlutterTts flutterTts = FlutterTts();
  // bool _isSpeaking = false;

  // Future<void> _speak(String text) async {
  //   await flutterTts.setLanguage("en-US");
  //   await flutterTts.setPitch(1.0); // 0.5 to 2.0
  //   await flutterTts.setSpeechRate(0.5); // 0.0 to 1.0
  //   await flutterTts.speak(text);
  // }

  @override
  void initState() {
    super.initState();
    // Play a [Media] or [Playlist].
    // 'https://user-images.githubusercontent.com/28951144/229373695-22f88f13-d18f-4288-9bf1-c3e078d83722.mp4',

    player.open(Media('asset:///assets/video/sample.mp4'));

    web_controller = WebviewController();

    web_controller.initialize().then((_) {
      setState(() => _isReady = true);
      web_controller.url.listen((_) => setState(() {}));
      web_controller.loadingState.listen((event) {
        print(event);
        setState(() => _isLoading = event == LoadingState.loading);
      });
      web_controller.loadUrl('https://miot.pcm-life.com');
    });
  }

  @override
  void dispose() {
    // player.dispose();
    super.dispose();
  }

  Future<void> _playLocalAsset() async {
    final playerx = AudioPlayer();
    await playerx.play(AssetSource('sounds/background.mp3'));
  }

  // @override
  // Widget build(BuildContext context) {
  //   return const Placeholder();
  // }

  @override
  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();

    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _playLocalAsset,
                  child: Text('Play Audio'),
                ),
              ],
            ),
          ),
          Column(
            children: [
              // Left 50%: Webview
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5 - 50,
                child: Webview(web_controller),
              ),
              // Right 50%: Video
              SizedBox(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height * 0.5 - 50,
                child: AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Video(controller: controller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
