import 'package:just_audio/just_audio.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';

void playsound() async {
  //เสียงค่าวัดเข้า
  late AudioPlayer _audioPlayer;
  String audio = DataProvider().audio;
  _audioPlayer = AudioPlayer()..setAsset('assets/sounds/$audio');
  await _audioPlayer.play();
}

void keypad_sound() async {
  //เสียงปุ่มกด
  late AudioPlayer _audioPlayer;
  String audio = DataProvider().audio;
  _audioPlayer = AudioPlayer()
    ..setAsset('assets/sounds/click_effect-86995.mp3');
  await _audioPlayer.play();
}
