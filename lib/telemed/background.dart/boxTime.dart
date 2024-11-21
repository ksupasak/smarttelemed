import 'dart:async';

import 'package:flutter/material.dart';

class BoxTime extends StatefulWidget {
  const BoxTime({super.key});

  @override
  State<BoxTime> createState() => _BoxTimeState();
}

class _BoxTimeState extends State<BoxTime> {
  DateTime dateTime = DateTime.parse('0000-00-00 00:00');
  String data = "";
  Timer? timer;
  @override
  void initState() {
    start();
    // TODO: implement initState
    super.initState();
  }

  void start() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        dateTime = DateTime.now();
        data =
            "${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}:${dateTime.second.toString().padLeft(2, '0')}";
      });
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: const Color.fromARGB(255, 255, 255, 255),
        fontSize: width * 0.03,
        fontWeight: FontWeight.w600);
    return Text(data.toString(), style: style);
  }
}
