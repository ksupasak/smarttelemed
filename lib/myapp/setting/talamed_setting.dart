// ignore_for_file: prefer_is_empty

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/myapp/provider/provider.dart';
import 'package:smarttelemed/myapp/setting/local.dart';

class TalamedSetting extends StatefulWidget {
  const TalamedSetting({super.key});

  @override
  State<TalamedSetting> createState() => _TalamedSettingState();
}

class _TalamedSettingState extends State<TalamedSetting> {
  bool statusSafe = false;
  bool isSwitchedINHospital = true;
  bool isSwitchedRequireIdCard = true;
  bool isSwitchedRequireVN = true;

  List<RecordSnapshot<int, Map<String, Object?>>>? dataconfig;

  TextEditingController text_no_idcard = TextEditingController();
  TextEditingController text_no_hn = TextEditingController();
  TextEditingController text_no_vn = TextEditingController();

  void saveconfig() {
    setState(() {
      statusSafe = true;
    });

    debugPrint("saveconfig");
    context.read<DataProvider>().in_hospital = isSwitchedINHospital;
    context.read<DataProvider>().requirel_id_card = isSwitchedRequireIdCard;
    context.read<DataProvider>().require_VN = isSwitchedRequireVN;
    setState(() {});
    Map<dynamic, dynamic> data = {
      'in_hospital': isSwitchedINHospital.toString(),
      'requirel_id_card': isSwitchedRequireIdCard.toString(),
      'require_VN': isSwitchedRequireVN.toString(),
      'text_no_idcard': text_no_idcard.text,
      'text_no_hn': text_no_hn.text,
      'text_no_vn': text_no_vn.text,
    };
    addDataInOutHospital(data);
    Future.delayed(const Duration(milliseconds: 500), () {
          setState(() {
      statusSafe = false;
    });
    });

  }

  void getconfig() async {
    dataconfig = await getInOutHospital();
    debugPrint("dataconfig INHospital $dataconfig");
    if (dataconfig?.length != 0) {
      for (RecordSnapshot<int, Map<String, Object?>> record in dataconfig!) {
        if (record["in_hospital"] != "true") {
          isSwitchedINHospital = false;
          setState(() {});
        }
        if (record['requirel_id_card'] != "true") {
          isSwitchedRequireIdCard = false;
          setState(() {});
        }
        if (record['require_VN'] != "true") {
          isSwitchedRequireVN = false;
          setState(() {});
        }
        text_no_idcard.text = record["text_no_idcard"].toString();
        text_no_hn.text = record["text_no_hn"].toString();
        text_no_vn.text = record["text_no_vn"].toString();
      }
    }
  }

  @override
  void initState() {
    getconfig();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: GestureDetector(
                onTap: () {
                  saveconfig();
                },
                child: statusSafe == false
                    ? const Icon(
                        Icons.save,
                        color: Colors.black,
                      )
                    : const CircularProgressIndicator(),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("IN Hospital", style: TextStyle(fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedINHospital,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedINHospital = value;
                        isSwitchedRequireVN = true;
                        isSwitchedRequireIdCard = true;
                        saveconfig();
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Require Id Card",
                      style: TextStyle(
                          color:
                              isSwitchedINHospital ? Colors.black : Colors.grey,
                          fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedRequireIdCard,
                    onChanged: (value) {
                      setState(() {
                        if (isSwitchedINHospital == true) {
                          isSwitchedRequireIdCard = value;
                          saveconfig();
                        }
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Require VN",
                      style: TextStyle(
                          color:
                              isSwitchedINHospital ? Colors.black : Colors.grey,
                          fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedRequireVN,
                    onChanged: (value) {
                      setState(() {
                        if (isSwitchedINHospital == true) {
                          isSwitchedRequireVN = value;
                          saveconfig();
                        }
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text("text_no_idcard",
                        style: TextStyle(fontSize: width * 0.04)),
                    TextField(
                      controller: text_no_idcard,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: " ",
                        hintStyle: TextStyle(
                          color: Colors.grey[600], // สีของ hintText
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text("text_no_hn",
                        style: TextStyle(fontSize: width * 0.04)),
                    
                       TextField(
                      controller: text_no_hn,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: " ",
                        hintStyle: TextStyle(
                          color: Colors.grey[600], // สีของ hintText
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
              SizedBox(
                child: Column(
                  children: [
                    Text("text_no_vn",
                        style: TextStyle(fontSize: width * 0.04)),
                  
                          TextField(
                      controller: text_no_vn,
                      maxLines: 5,
                      minLines: 5,
                      decoration: InputDecoration(
                        hintText: " ",
                        hintStyle: TextStyle(
                          color: Colors.grey[600], // สีของ hintText
                          fontSize: 16,
                        ),
                      ),
                      style: const TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
