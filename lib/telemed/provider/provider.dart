import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<String> debug = [];
  void debugPrintV(String data) {
    debug.add(data);
    debugPrint(data);
    notifyListeners();
  }

  String app = '';
  String name_hospital = '';
  String platfromURL = '';
  String platfromURLgeatway = 'https://goodwide.pythonanywhere.com';
  String password = '';
  String care_unit = '';
  String care_unit_id = '';
  bool in_hospital = true;
  bool requirel_id_card = true;
  bool require_VN = true;
  String text_no_idcard = '';
  String text_no_hn = '';
  String text_no_vn = '';
  Map<String, Object?> datamin_max = {
    "minspo2": '',
    "maxspo2": '',
    "minsys": '',
    "maxsys": '',
    "mindia": '',
    "maxdia": '',
    "mintemp": '',
    "maxtemp": '',
    "minbmi": '',
    "maxbmi": '',
  };
  String printername = '';
  Locale languageApp = const Locale('th');

  void setlanguageApp(Locale locale) {
    languageApp = locale;
    notifyListeners();
  }

///////////////////////////////
  Map dataUserIDCard = {};
  String id = '';
  String claimType = '';
  String claimTypeName = '';
  String correlationId = '';
  void updateuserinformation(Map data) {
    debugPrintV("พบข้อมูล ID Card :$data");

    dataUserIDCard = data;
    id = data["pid"];
    claimType = data['claimTypes'][0]["claimType"];
    claimTypeName = data['claimTypes'][0]["claimTypeName"];
    correlationId = data["correlationId"];
    notifyListeners();
  }

  String claimCode = '';
  void updateclaimCode(Map data) {
    claimCode = data["claimCode"];
    debugPrint("claimCode : $claimCode");
    notifyListeners();
  }

  Map datagateway = {};
  String hn = '';
  String vn = '';
  String prefixName = '';
  String fname = '';
  String lname = '';
  String phone = '';
  String imgae = '';
  String birthdate = '';
  void updateusergateway(Map data) {
    //https://goodwide.pythonanywhere.com/api/patient?cid=1111111111111
    debugPrintV("พบข้อมูล gateway $data");
    hn = data['data']['hn'];
    vn = data['data']['vn'];
    prefixName = data['data']['prefix_name'];
    fname = data['data']['fname'];
    lname = data['data']['lname'];
    phone = data['data']['phone'];
    imgae = data['data']['img'];
    birthdate = data['data']['birthdate'];
    notifyListeners();
  }

  void updateuserCard(Map data) {
    debugPrintV("พบข้อมูล Crde Reader :$data");
    String databirthDate;
    fname = data['fname'];
    lname = data['lname'];
    databirthDate = data['birthDate'];
    birthdate =
        "${databirthDate[0]}${databirthDate[1]}${databirthDate[2]}${databirthDate[3]}-${databirthDate[4]}${databirthDate[5]}-${databirthDate[6]}${databirthDate[7]}";
    notifyListeners();
  }

/////////////////////////////////////
  TextEditingController sysHealthrecord = TextEditingController();
  TextEditingController diaHealthrecord = TextEditingController();
  TextEditingController pulseHealthrecord = TextEditingController();
  TextEditingController heightHealthrecord = TextEditingController();
  TextEditingController weightHealthrecord = TextEditingController();
  TextEditingController spo2Healthrecord = TextEditingController();
  TextEditingController tempHealthrecord = TextEditingController();
  TextEditingController bmiHealthrecord = TextEditingController();
}
