import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  double buttonSized_w = 0.45;
  double buttonSized_h = 0.08;

  List<String> debug = [];
  void debugPrintV(String data) {
    if (data.length >= 1000) {
      debug.removeAt(0);
    }
    debug.add(data);
    debugPrint(data);
    notifyListeners();
  }

  bool windowManagersetFullScreen = true;
  String app = '';
  String name_hospital = '';
  String platfromURL = '';
  String platfromURLGateway = ''; //'https://goodwide.pythonanywhere.com';
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
  Locale? languageApp;

///////////////////////////////
  Map dataUserIDCard = {};
  String id = '';
  String claimType = '';
  String claimTypeName = '';
  String correlationId = '';
  String fname = '';
  String lname = '';
  String prefixName = '';
  String birthdate = '';
  String age = '';

  void updateuserinformation(Map data) {
    debugPrintV("พบข้อมูล ID Card :$data");
    dataUserIDCard = data;
    id = data["pid"];
    fname = data["fname"];
    lname = data["lname"];
    claimType = data['claimTypes'][0]["claimType"];
    claimTypeName = data['claimTypes'][0]["claimTypeName"];
    correlationId = data["correlationId"];
    age = data["age"];
    prefixName = getprefix_name(data["titleName"].toString());
    String databirthDate;
    databirthDate = data['birthDate'];
    birthdate =
        "${databirthDate[0]}${databirthDate[1]}${databirthDate[2]}${databirthDate[3]}-${databirthDate[4]}${databirthDate[5]}-${databirthDate[6]}${databirthDate[7]}";
    notifyListeners();
  }

  String getprefix_name(String titleName) {
    if (titleName == "001") {
      return "เด็กชาย";
    } else if (titleName == "002") {
      return "เด็กหญิง";
    } else if (titleName == "003") {
      return "นาย";
    }
    if (titleName == "004") {
      return "นางสาว";
    }
    if (titleName == "005") {
      return "นาง";
    } else {
      return "--";
    }
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
  String phone = '';
  String imgae = '';
  void updateusergateway(Map data) {
    //https://goodwide.pythonanywhere.com/api/patient?cid=1111111111111
    datagateway = data;
    debugPrintV("พบข้อมูล gateway $data");
    hn = data['data']['hn'];
    vn = data['data']['vn'];
    prefixName = data['data']['prefix_name'];
    fname = data['data']['fname'];
    lname = data['data']['lname'];
    phone = data['data']['phone'];
    imgae = data['data']['img'].toString();
    birthdate = data['data']['birthdate'];
    notifyListeners();
  }

  // void updateuserCard(Map data) {
  //   debugPrintV("พบข้อมูล Crde Reader :$data");
  //   fname = data['fname'];
  //   lname = data['lname'];
  //   notifyListeners();
  // }

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
