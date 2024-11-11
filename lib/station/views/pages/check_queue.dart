// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/popup.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

class CheckQueue extends StatefulWidget {
  const CheckQueue({super.key});

  @override
  State<CheckQueue> createState() => _CheckQueueState();
}

class _CheckQueueState extends State<CheckQueue> {
  var resTojson;
  String textqueue = 'not found today appointment1';
  bool statusbottom = false;
  void checkqueue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    resTojson = json.decode(res.body);

    if (res.statusCode == 200) {
      setState(() {
        debugPrint(resTojson['message']);
      });
    }
  }

  void printqueue() {
    if (resTojson != null) {
      setState(() {
        statusbottom = true;
      });
      if (resTojson['message'] != textqueue) {
        debugPrint('ปริ้นคิว');
        setState(() {
          statusbottom = false;
        });
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Popup(
                  fontSize: 0.05,
                  texthead: 'รับคิวที่เครื่อง',
                  textbody: 'กำลังปริ้นคิว...',
                  pathicon: 'assets/9df753370d3f57e6d1325129db200f93.gif');
            });
        Timer(const Duration(seconds: 2), () {
          Navigator.pop(context);
          Navigator.pop(context);
        });
      } else {
        setState(() {
          statusbottom = false;
        });
      }
    }
  }

  @override
  void initState() {
    checkqueue();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(children: [
        const backgrund(),
        Positioned(
            child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              resTojson == null
                  ? Text(
                      'กำลังโหลด...',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().fontFamily,
                          color: Colors.white,
                          fontSize: height * 0.03),
                    )
                  : Text(
                      '${resTojson['message']}',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().fontFamily,
                          color: Colors.white,
                          fontSize: height * 0.03),
                    ),
              SizedBox(height: height * 0.02),
              MarkCheck(height: 0.2, width: 0.4, pathicon: 'assets/queue.png'),
              SizedBox(height: height * 0.02),
              statusbottom == false
                  ? GestureDetector(
                      onTap: () {
                        printqueue();
                      },
                      child: BoxWidetdew(
                        fontSize: 0.05,
                        height: 0.08,
                        width: 0.4,
                        color: resTojson == null
                            ? const Color.fromARGB(100, 89, 204, 93)
                            : resTojson['message'] == textqueue
                                ? const Color.fromARGB(100, 89, 204, 93)
                                : const Color.fromARGB(255, 0, 255, 8),
                        text: resTojson == null
                            ? 'กำลังโหลด...'
                            : resTojson['message'] == textqueue
                                ? 'ไม่มีคิว'
                                : 'ปริ้นคิว',
                        textcolor: resTojson == null
                            ? const Color.fromARGB(100, 255, 255, 255)
                            : resTojson['message'] == textqueue
                                ? const Color.fromARGB(200, 255, 255, 255)
                                : const Color.fromARGB(255, 255, 255, 255),
                      ),
                    )
                  : SizedBox(
                      width: MediaQuery.of(context).size.width * 0.07,
                      height: MediaQuery.of(context).size.width * 0.07,
                      child: const CircularProgressIndicator(),
                    ),
              SizedBox(height: height * 0.02),
              GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: BoxWidetdew(
                  fontSize: 0.05,
                  height: 0.08,
                  width: 0.4,
                  color: const Color.fromARGB(255, 255, 0, 0),
                  text: 'ออก',
                  textcolor: const Color.fromARGB(255, 255, 255, 255),
                ),
              ),
            ],
          ),
        ))
      ]),
    );
  }
}
