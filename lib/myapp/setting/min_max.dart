import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/myapp/setting/local.dart';

class SettingMinMax extends StatefulWidget {
  const SettingMinMax({super.key});

  @override
  State<SettingMinMax> createState() => _SettingMinMaxState();
}

class _SettingMinMaxState extends State<SettingMinMax> {
  bool statusSafe = false;
  TextEditingController minSYS = TextEditingController();
  TextEditingController maxSYS = TextEditingController();
  //
  TextEditingController minDIS = TextEditingController();
  TextEditingController maxDIS = TextEditingController();
  //
  TextEditingController minTEMP = TextEditingController();
  TextEditingController maxTEMP = TextEditingController();
  //
  TextEditingController minSPO2 = TextEditingController();
  TextEditingController maxSPO2 = TextEditingController();
  //
  TextEditingController minBMI = TextEditingController();
  TextEditingController maxBMI = TextEditingController();
  //
  List<RecordSnapshot<int, Map<String, Object?>>>? data;
  void savevalue() {
    Map<String, Object?> data = {
      "minspo2": minSPO2.text,
      "maxspo2": maxSPO2.text,
      "minsys": minSYS.text,
      "maxsys": maxSYS.text,
      "mindia": minDIS.text,
      "maxdia": maxDIS.text,
      "mintemp": minTEMP.text,
      "maxtemp": maxTEMP.text,
      "minbmi": minBMI.text,
      "maxbmi": maxBMI.text,
    };
    setState(() {
      statusSafe = true;
    });
    addDataMinMax(data);
    Future.delayed(const Duration(milliseconds: 500), () {
      setState(() {
        statusSafe = false;
      });
    });
  }

  void getvalue() async {
    data = await getInMinMax();
    debugPrint(data.toString());
    if (data != []) {
      for (RecordSnapshot<int, Map<String, Object?>> record in data!) {
        minSYS.text = record["minsys"].toString();
        maxSYS.text = record["maxsys"].toString();
        minSPO2.text = record["minspo2"].toString();
        maxSPO2.text = record["maxspo2"].toString();
        minDIS.text = record["mindia"].toString();
        maxDIS.text = record["maxdia"].toString();

         minTEMP.text = record["mintemp"].toString();
        maxTEMP.text = record["maxtemp"].toString();
        minBMI.text = record["minbmi"].toString();
        maxBMI.text = record["maxbmi"].toString();
      }
    }
  }

  @override
  void initState() {
    getvalue();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                savevalue();
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
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SYS",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
              Text(
                "min",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minSYS,
                ),
              ),
              Text(
                "max",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: maxSYS,
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "DIS",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
              Text(
                "min",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minDIS,
                ),
              ),
              Text(
                "max",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: maxDIS,
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "TEMP",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
              Text(
                "min",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minTEMP,
                ),
              ),
              Text(
                "max",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: maxTEMP,
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "SPO2",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
              Text(
                "min",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minSPO2,
                ),
              ),
              Text(
                "max",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: maxSPO2,
                ),
              )
            ],
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  "BMI",
                  style: TextStyle(fontSize: width * 0.03),
                ),
              ),
              Text(
                "min",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: minBMI,
                ),
              ),
              Text(
                "max",
                style: TextStyle(fontSize: width * 0.03),
              ),
              SizedBox(
                width: width * 0.3,
                child: TextField(
                  keyboardType: TextInputType.number,
                  controller: maxBMI,
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
