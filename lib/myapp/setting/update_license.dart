import 'dart:io';

import 'package:flutter/material.dart';
import 'package:smarttelemed/share/devices/esm_idcard.dart';

class Update_License extends StatefulWidget {
  const Update_License({super.key});

  @override
  State<Update_License> createState() => _Update_LicenseState();
}

class _Update_LicenseState extends State<Update_License> {
  String value = 'ว่าง';
  File? imageFile;

  ESMIDCard? reader;

  Stream<String>? entry;
  // ignore: non_constant_identifier_names
  Stream<String>? reader_status;

  void updateLicense() {
    Future.delayed(const Duration(seconds: 2), () {
      reader = ESMIDCard.instance;

      reader?.getEntry();

      reader_status = reader?.getStatus();
      reader_status?.listen((String data) async {
        print("Reader Status :  " + data);

        if (data == "ADAPTER_READY") {
          reader?.findReader();
        } else if (data == "DEVICE_READY") {
          reader?.updateLicenseFileDF();
          // const oneSec = Duration(seconds: 2);
          //
          // reading = Timer.periodic(oneSec, (Timer t) => checkCard());
        }
      });

      setState(() {
        value = 'Updated Lisense OK ';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Update License',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Color(0xffffffff),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView(children: [
        SizedBox(
          width: _width,
          child: Center(child: Text('$value')),
        ),
        SizedBox(
            width: _width,
            child: Center(
                child: ElevatedButton(
                    onPressed: () {
                      updateLicense();
                    },
                    child: const Text('Update License'))))
      ]),
    );
  }
}
