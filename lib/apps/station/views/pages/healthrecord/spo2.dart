import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/station/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'dart:io';

class Spo2Healthrecord extends StatefulWidget {
  const Spo2Healthrecord({super.key});

  @override
  State<Spo2Healthrecord> createState() => _Spo2HealthrecordState();
}

class _Spo2HealthrecordState extends State<Spo2Healthrecord> {
  List availablePorts = [];
  SerialPort? current_port = null;

  void start() async {
    bool connect = false;

    // while (true) {
    try {
      // final name = SerialPort.availablePorts.first;
      for (var name in SerialPort.availablePorts) {
        debugPrint('scan $name');
        final port = SerialPort(name);
        if (port.vendorId == 1659) {
          debugPrint("found SPO2");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
            exit(-1);
          }
          current_port = port;

          debugPrint("open SPO2");

          SerialPortConfig config = port.config;
          config.baudRate = 38400;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          debugPrint("reader SPO2");

          reader.stream.listen((data) {
            if (data[0] == 42) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (buffer.length == 11) {
                debugPrint('Buffer: $buffer');
                if (buffer[2] == 83) {
                  int spo2 = buffer[5];
                  int pulse = buffer[6];
                  debugPrint('SpO2: $spo2, Pulse:$pulse');
                  if (spo2 > 0 && pulse > 0) {
                    context.read<DataProvider>().spo2Healthrecord.text = spo2
                        .toString();
                    context.read<DataProvider>().pulseHealthrecord.text = pulse
                        .toString();
                  }
                }

                buffer = [];

                status = 0;
              }
            }
          });
        }
      }
    } on Exception catch (_) {
      print("throwing new error");
      // throw Exception("Error on server");
    }
    // }
  }

  void initPorts() {
    try {
      //    setState(() => availablePorts = SerialPort.availablePorts);
      debugPrint('Available ports: ${availablePorts.length}');
    } catch (e) {
      debugPrint('Error retrieving ports: $e');
      setState(() => availablePorts = []);
    }
  }

  @override
  void initState() {
    super.initState();
    start();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
      height: height * 0.7,
      width: width,
      child: ListView(
        children: [
          SizedBox(
            height: height * 0.4,
            width: height * 0.4,
            child: Center(
              child: Image.asset("assets/unnamed.jpg", fit: BoxFit.fill),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                  image: 'assets/kauo.png',
                  texthead: 'SPO2',
                  keyvavlue: context.read<DataProvider>().spo2Healthrecord,
                ),
                BoxRecord(
                  image: 'assets/jhbjk;.png',
                  texthead: 'PULSE',
                  keyvavlue: context.read<DataProvider>().pulseHealthrecord,
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    dataProvider.updateviewhealthrecord("pulseAndSysAndDia");
                    debugPrint(
                      context.read<DataProvider>().viewhealthrecord.toString(),
                    );
                  },
                  child: Text(
                    "ย้อนกลับ",
                    style: TextStyle(fontSize: width * 0.03),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    dataProvider.updateviewhealthrecord("sum");
                  },
                  child: Text(
                    "ถัดไป",
                    style: TextStyle(fontSize: width * 0.03),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();

    if (current_port != null) {
      current_port?.close();
    }
  }
}
