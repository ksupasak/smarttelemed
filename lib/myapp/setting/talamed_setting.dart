import 'package:flutter/material.dart';

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
                onTap: () {},
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
                    Text("IN Hospital",style: TextStyle(
                                                      fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedINHospital,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedINHospital = value;
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
                    Text("Require Id Card",style: TextStyle(
                                                      fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedRequireIdCard,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedRequireIdCard = value;
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
                    Text("Require VN",style: TextStyle(
                                                      fontSize: width * 0.04)),
                  Switch(
                    value: isSwitchedRequireVN,
                    onChanged: (value) {
                      setState(() {
                        isSwitchedRequireVN = value;
                      });
                    },
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.grey,
                  ),
                ],
              ),
              SizedBox(
                height: height * 0.2,
               child:TextField(style: TextStyle(
                                                      fontSize: width * 0.04)) ,),
              
              
            ],
          ),
        ));
  }
}
