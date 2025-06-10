// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:flutter/material.dart';

class BoxRecord extends StatefulWidget {
  BoxRecord(
      {super.key,
      this.keyvavlue,
      this.texthead,
      this.icon,
      this.image,
      this.color});
  var keyvavlue;
  var texthead;
  var image;
  Widget? icon;
  Color? color;
  @override
  State<BoxRecord> createState() => _BoxRecordState();
}

class _BoxRecordState extends State<BoxRecord> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Color teamcolor = Color.fromARGB(255, 35, 131, 123);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // height: _height * 0.1,
        width: _width * 0.2,
        color: Colors.white,
        child: Column(
          children: [
            widget.texthead == null
                ? Text('')
                : Row(
                    children: [
                      widget.image != null
                          ? Container(
                              width: _width * 0.05,
                              child: Image.asset(widget.image))
                          : SizedBox(),
                      Text('${widget.texthead}',
                          style: TextStyle(
                              fontSize: _width * 0.03, color: teamcolor)),
                    ],
                  ),
            TextField(
              cursorColor: teamcolor,
              onTap: () async {
                try {
                  // เรียกใช้งาน cmd.exe
                  final process = await Process.start(
                    'runas',
                    ['/user:Administrator', 'C:\\Windows\\System32\\osk.exe'],
                  );

                  // ดักจับผลลัพธ์จาก stdout และ stderr
                  process.stdout
                      .transform(SystemEncoding().decoder)
                      .listen((data) {
                    print('stdout: $data');
                  });
                  process.stderr
                      .transform(SystemEncoding().decoder)
                      .listen((data) {
                    print('stderr: $data');
                  });
                } catch (e) {
                  print('Error starting process: $e');
                }
              },
              onChanged: (value) {
                if (value.isNotEmpty) {}
              },
              decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                    color: teamcolor,
                  ),
                ),
              ),
              style: TextStyle(
                color: teamcolor,
                fontSize: _height * 0.03,
              ),
              controller: widget.color ?? widget.keyvavlue,
              keyboardType: TextInputType.number,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
