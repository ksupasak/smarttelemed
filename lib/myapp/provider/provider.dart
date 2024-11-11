import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List creadreader = [];
  var photo;
  String user_name = '';
  String user_id = '';
  bool status_internet = true;
  String user_code = '';
  List list_patients = [];
  bool permission_card_reader = true;
  String app = '';
  String appId = '';
  String platfromURL = 'https://emr-life.com/clinic_master/clinic/Api/';
  String platfromURLopenvidu =
      'https://openvidu.pcm-life.com'; //'https://pcm-life.com:4443/openvidu';
  String name_hospital = '';
  String care_unit = '';
  String care_unit_id = '';
  String password = '';
  bool permission_id = false;
  bool permission_ble = false;
  bool permission_printter = false;
  String? family = 'prompt';
  var resTojson;
  String id = '';
  String? p_name;
  String? f_name;
  String? l_name;
  String colortexts = '';
  String audio = 'massad.mp3';
  String temp = '';
  String weight = '';
  String sys = '';
  String dia = '';
  String spo2 = '';
  String pr = '';
  String pul = '';
  String fbs = '';
  String si = '';
  String uric = '';
  List<String> namescan = [
    //  'FT_F5F30C4C52DE', //เครื่องอ่านบัตร
    'Yuwell HT-YHW', //เครื่องวัดอุณหภูมิ D0:05:10:00:02:74
    // 'Yuwell BO-YX110-FDC7', //เครื่องspo2  Yuwell_BO_YX110_FDC7
    'Yuwell BP-YE680A', //เครื่องวัดความดัน  Yuwell_BP_YE680A
    'MIBFS', //เครื่องชั่ง
    'HJ-Narigmed', //เครื่องspo2
    'HC-08', //เครื่องวัดอุณหภูมิ
    'A&D_UA-651BLE_D57B3F', //เครื่องวัดความดัน
    'Yuwell Glucose', //เครื่องวัดน้ำตาล
    'Yuwell BO-YX110', //เครื่องspo2
  ];
  Map<String, String> imagesdevice = {
    // 'FT_F5F30C4C52DE': '',
    'Yuwell HT-YHW': 'LINE_ALBUM_yuwell_230620.jpg',
    'Yuwell BP-YE680A': 'LINE_ALBUM_yuwell_230618.jpg',
    //'Yuwell BO-YX0-11FDC7': 'LINE_ALBUM_yuwell_230619.jpg',
    'MIBFS': 'LINE_ALBUM_yuwell_230623.png',
    'HJ-Narigmed': 'sg-11134201-23010-ka1jtswb8smvff.jpg',
    'HC-08': 'HTD8808E-Bluetooth-wireless-thermometer_2.jpg',
    'A&D_UA-651BLE_D57B3F': 'UA-651BLE-complete.jpg',
    'Yuwell Glucose': 'LINE_ALBUM_yuwell_230621.jpg',
    'Yuwell BO-YX110': 'LINE_ALBUM_yuwell_230619.jpg'
  };
  Map<String, String> namedevice = {
    //  'FT_F5F30C4C52DE': 'เครื่องอ่านบัตรประชน',
    'Yuwell HT-YHW': 'เครื่องวัดอุณหภูมิ',
    'Yuwell BP-YE680A': 'เครื่องวัดความดัน',
    // 'Yuwell BO-YX110-FDC7': 'เครื่องวัดspo2',
    'MIBFS': 'เครื่องชั่งน้ำหนัก',
    'HJ-Narigmed': 'เครื่องวัดspo2',
    'HC-08': 'เครื่องวัดอุณหภูมิ',
    'A&D_UA-651BLE_D57B3F': 'เครื่องวัดความดัน',
    'Yuwell Glucose': 'เครื่องวัดน้ำตาล',
    'Yuwell BO-YX110': 'เครื่องวัด spo2',
  };
  List<String> iddevice = [];
  var mapdevices;

  List health_record_offline = [];
}

// bool yuwell_Glucose = false;
