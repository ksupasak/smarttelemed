import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

class Datafunction with ChangeNotifier {
  // late Timer scanTimer;
  // void scan(bool scan) {
  //   scanTimer([int milliseconds = 4000]) =>
  //       Timer.periodic(Duration(milliseconds: milliseconds), (Timer timer) {
  //         FlutterBluePlus.instance.startScan(timeout: Duration(seconds: 4));
  //       });
  // }

  void playsound() async {
    // late AudioPlayer _audioPlayer;
    // _audioPlayer = AudioPlayer()..setAsset('assets/sounds/Sin2.mp3');
    // await _audioPlayer.play();
  }

  double checkDigit(String id) {
    int sum = 0;
    for (int i = 0; i < 12; i++) {
      int digit = int.parse(id[i]);
      sum += digit * (13 - i);
    }

    int remainder = sum % 11;
    double result = (11 - remainder) % 10;

    return result;
  }
  // Future<bool> sendinformation(String id, String urlname) async {
  //   var resTojson;
  //   bool status = false;
  //   var url = Uri.parse(
  //       'https://emr-life.com/clinic_master/clinic/Api/get_patient?public_id=$id'); //${context.read<stringitem>().uri}
  //   var res = await http.get(url);
  //   resTojson = json.decode(res.body);
  //   if (resTojson['message'] == 'success') {
  //     status = true;
  //   }
  //   return status;
  // }
}
