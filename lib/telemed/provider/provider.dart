import 'package:flutter/material.dart';

class DataProvider with ChangeNotifier {
  List<String> debug = [];

  void debugPrint(String data) {
    debug.add(data);
    notifyListeners();
  }

///////////////////////////////
  String app = '';
  String name_hospital = '';
  String platfromURL = '';
  String password = '';
  String care_unit = '';
  String care_unit_id = '';

///////////////////////////////
  bool in_hospital = true;
  bool requirel_id_card = true;
  bool require_VN = true;
  String text_no_idcard = '';
  String text_no_hn = '';
  String text_no_vn = '';
///////////////////////////////
  String printername = '';
///////////////////////////////
}
