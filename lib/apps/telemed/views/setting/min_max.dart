import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:smarttelemed/apps/telemed/data/models/station/local.dart';

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
    data = await getMinMax();
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

  Widget box({
    required String name,
    required TextEditingController dataTextMin,
    required TextEditingController dataTextMax,
  }) {
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          color: const Color.fromARGB(255, 255, 255, 255),
          boxShadow: const [
            BoxShadow(blurRadius: 5.0, color: Color.fromARGB(255, 63, 86, 83)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(name, style: TextStyle(fontSize: width * 0.03)),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Min", style: TextStyle(fontSize: width * 0.03)),
                ),
                SizedBox(
                  width: width * 0.3,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: dataTextMin,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Max", style: TextStyle(fontSize: width * 0.03)),
                ),
                SizedBox(
                  width: width * 0.3,
                  child: TextField(
                    textAlign: TextAlign.center,
                    keyboardType: TextInputType.number,
                    controller: dataTextMax,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
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
                  ? const Icon(Icons.save, color: Colors.black)
                  : const CircularProgressIndicator(),
            ),
          ),
        ],
      ),
      body: ListView(
        children: [
          box(name: "SYS", dataTextMin: minSYS, dataTextMax: maxSYS),
          box(name: "DIA", dataTextMin: minDIS, dataTextMax: maxDIS),
          box(name: "TEMP", dataTextMin: minTEMP, dataTextMax: maxTEMP),
          box(name: "SPO2", dataTextMin: minSPO2, dataTextMax: maxSPO2),
          box(name: "BMI", dataTextMin: minBMI, dataTextMax: maxBMI),
        ],
      ),
    );
  }
}
