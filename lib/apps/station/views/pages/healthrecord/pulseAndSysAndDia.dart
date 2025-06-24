import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/station/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';

class PulseAndSysAndDia extends StatefulWidget {
  const PulseAndSysAndDia({super.key});

  @override
  State<PulseAndSysAndDia> createState() => _PulseAndSysAndDiaState();
}

class _PulseAndSysAndDiaState extends State<PulseAndSysAndDia> {
  List availablePorts = [];
  SerialPort? current_port = null;

  String intArrayToString(List<int> intArray) {
    // Filter out values greater than 127
    List<int> filteredIntArray = intArray
        .where((value) => value <= 127)
        .toList();

    return String.fromCharCodes(filteredIntArray);
  }

  void startBP() async {
    bool connect = false;

    // while (true) {
    try {
      // final name = SerialPort.availablePorts.first;
      for (var name in SerialPort.availablePorts) {
        debugPrint('scan $name');
        final port = SerialPort(name);
        if (port.vendorId == 8137) {
          debugPrint("found BP");
          int status = 0;
          if (!port.openReadWrite()) {
            print(SerialPort.lastError);
          }
          current_port = port;

          debugPrint("open BP");

          SerialPortConfig config = port.config;
          config.baudRate = 9600;
          port.config = config;

          List<int> buffer = [];
          final reader = SerialPortReader(port);

          debugPrint("reader BP");

          reader.stream.listen((data) {
            debugPrint('$data');

            if (data[0] == 50) {
              status = 1;
            }

            if (status == 1) {
              buffer.addAll(data);

              if (true) {
                debugPrint('Buffer: $buffer');

                String txt = intArrayToString(buffer);
                debugPrint('$txt');

                List<String> splitList = txt.split(";");

                int sys = int.parse(splitList[3].split(":")[1].split(" ")[0]);

                int dia = int.parse(splitList[5].split(":")[1].split(" ")[0]);

                debugPrint('Sys: $sys, Dia:$dia');
                context.read<DataProvider>().sysHealthrecord.text = sys
                    .toString();
                context.read<DataProvider>().diaHealthrecord.text = dia
                    .toString();

                buffer = [];

                status = 0;
              }
            }
          });
        }
      }
    } on Exception catch (_) {
      print("throwing new error");
    }
  }

  @override
  void initState() {
    super.initState();
    startBP();
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
              child: Image.asset("assets/ye990.png", fit: BoxFit.fill),
            ),
          ),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                  image: 'assets/jhv.png',
                  texthead: 'SYS',
                  keyvavlue: context.read<DataProvider>().sysHealthrecord,
                ),
                BoxRecord(
                  image: 'assets/jhvkb.png',
                  texthead: 'DIA',
                  keyvavlue: context.read<DataProvider>().diaHealthrecord,
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
                    dataProvider.updateviewhealthrecord("heightAndWidth");
                  },
                  child: Text(
                    "ย้อนกลับ",
                    style: TextStyle(fontSize: width * 0.03),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    dataProvider.updateviewhealthrecord("spo2");
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
    super.dispose();

    if (current_port != null) {
      current_port?.close();
    }
  }
}
