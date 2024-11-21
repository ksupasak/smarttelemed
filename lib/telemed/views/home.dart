import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/setting/ui/numpad.dart';
import 'package:smarttelemed/telemed/views/ui/stylebutton.dart';
import 'package:smarttelemed/telemed/views/userInformation.dart';

class HomeTelemed extends StatefulWidget {
  const HomeTelemed({super.key});

  @override
  State<HomeTelemed> createState() => _HomeTelemedState();
}

class _HomeTelemedState extends State<HomeTelemed> {
  Timer? timerreadIDCard;
  bool shownumpad = false, status = false;

  @override
  void initState() {
    //  getIdCard();
    super.initState();
  }

  void getIdCard() async {
    DataProvider dataProvider = context.read<DataProvider>();
    dataProvider
        .debugPrintV("Start Crde Reader--------------------------------=");
    timerreadIDCard = Timer.periodic(const Duration(seconds: 1), (timer) async {
      var url = Uri.parse('http://localhost:8189/api/smartcard/read');
      var res = await http.get(url);
      var resTojson = json.decode(res.body);
      debugPrint("Crde Reader--------------------------------=");
      if (res.statusCode == 200) {
        context.read<DataProvider>().updateuserinformation(resTojson);
        timerreadIDCard?.cancel();
        dataProvider
            .debugPrintV("Stop Crde Reader--------------------------------=");
        setState(() {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (context) => const Userinformation()));
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          Positioned(
            child: SizedBox(
              width: width,
              height: height,
              child: ListView(
                children: [
                  SizedBox(
                    height: height,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: width * 0.7,
                          height: height * 0.07,
                          decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 235, 235, 235),
                              borderRadius: BorderRadius.circular(15)),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      shownumpad = !shownumpad;
                                    });
                                  },
                                  child: const BoxID()),
                            ],
                          ),
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.005),
                        shownumpad == true
                            ? Column(
                                children: [
                                  Numpad(),
                                  SizedBox(height: height * 0.01),
                                  status == false
                                      ? ElevatedButton(
                                          style: stylebutter(Colors.green),
                                          onPressed: () {},
                                          child: Text("data"))
                                      : SizedBox(
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.05,
                                          child:
                                              const CircularProgressIndicator(),
                                        ),
                                ],
                              )
                            : SizedBox(
                                height: height * 0.3,
                                width: width * 0.5,
                                child: Image.asset('assets/ppasc.png'),
                              )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
