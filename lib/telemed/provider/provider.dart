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
}
