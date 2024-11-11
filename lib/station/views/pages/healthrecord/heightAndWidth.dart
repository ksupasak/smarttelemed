import 'package:flutter/material.dart';
import 'package:get/get.dart'; 
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart';
import 'package:smarttelemed/station/views/ui/widgetdew.dart/widgetdew.dart';

class HeightAndWidth extends StatefulWidget {
  const HeightAndWidth({super.key});

  @override
  State<HeightAndWidth> createState() => _HeightAndWidthState();
}

class _HeightAndWidthState extends State<HeightAndWidth> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    DataProvider dataProvider = context.read<DataProvider>();
    return SizedBox(
        height: height * 0.7,
        width: width,
        child: ListView(children: [
          SizedBox(
              height: height * 0.4,
              width: height * 0.4,
              child: Center(
                child: Image.asset(
                  "assets/1117.png",
                  fit: BoxFit.fill,
                ),
              )),
          Center(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                BoxRecord(
                    image: 'assets/shr.png',
                    texthead: 'HEIGHT',
                    keyvavlue: context.read<DataProvider>().heightHealthrecord),
                BoxRecord(
                    image: 'assets/srhnate.png',
                    texthead: 'WEIGHT',
                    keyvavlue: context.read<DataProvider>().weightHealthrecord),
                BoxRecord(
                    image: 'assets/jhgh.png',
                    texthead: 'TEMP',
                    keyvavlue: context.read<DataProvider>().tempHealthrecord),
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
                        Get.toNamed('user_information');
                        debugPrint(context
                            .read<DataProvider>()
                            .viewhealthrecord
                            .toString());
                      },
                      child: Text(
                        "ย้อนกลับ",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      )),
                  ElevatedButton(
                      onPressed: () {
                        dataProvider
                            .updateviewhealthrecord("pulseAndSysAndDia");

                        debugPrint(context
                            .read<DataProvider>()
                            .viewhealthrecord
                            .toString());
                      },
                      child: Text(
                        "ถัดไป",
                        style: TextStyle(
                          fontSize: width * 0.03,
                        ),
                      ))
                ]),
          )
        ]));
  }
}
