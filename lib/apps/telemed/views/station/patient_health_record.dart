import 'package:flutter/material.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/provider.dart';
import 'package:smarttelemed/apps/telemed/views/ui/informationCard.dart';
import 'package:smarttelemed/apps/telemed/core/services/background.dart/background.dart';
import 'package:smarttelemed/apps/telemed/views/station/stage.dart';
import 'package:smarttelemed/apps/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/l10n/app_localizations.dart';

class PatientHealthRecord extends StatefulWidget {
  const PatientHealthRecord({Key? key}) : super(key: key);
  @override
  State<PatientHealthRecord> createState() => PatientHealthRecordState();
}

class PatientHealthRecordState extends State<PatientHealthRecord> {
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

    DataProvider provider = context.read<DataProvider>();

    web_controller.initialize().then((_) {
      setState(() => _isReady = true);
      web_controller.url.listen((_) => setState(() {}));
      web_controller.loadingState.listen((event) {
        print(event);
        setState(() => _isLoading = event == LoadingState.loading);
      });
      print(provider.health_url);
      web_controller.loadUrl(provider.health_url);
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

    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.read<DataProvider>();

    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SizedBox(
            width: width,
            height: height,
            child: ListView(
              children: [
                SizedBox(height: height * 0.13),
                Center(
                  child: Container(
                    width: width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 0.5,
                          color: Color(0xff48B5AA),
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: const Center(child: InformationCard()),
                  ),
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: 50,
                ),
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  height: MediaQuery.of(context).size.height - 100,
                  child: Webview(web_controller),
                ),
                SizedBox(height: height * 0.02),

                Center(
                  child: ElevatedButton(
                    style: stylebutter(
                      const Color.fromARGB(255, 175, 129, 76),
                      width * provider.buttonSized_w,
                      height * provider.buttonSized_h,
                    ),
                    onPressed: () {
                      context.read<DataProvider>().setPage(
                        Stage.PATIENT_HOME_SCREEN,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.userinformation_OK,
                      style: TextStyle(
                        fontSize: width * 0.06,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.02),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
