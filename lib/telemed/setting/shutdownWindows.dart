import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smarttelemed/station/main_app/app.dart';

class ShutdownWindows extends StatefulWidget {
  const ShutdownWindows({super.key});

  @override
  State<ShutdownWindows> createState() => _ShutdownWindowsState();
}

class _ShutdownWindowsState extends State<ShutdownWindows> {
  void shutdownWindows() {
    // ใช้คำสั่ง shutdown ใน Windows
    Process.run('shutdown', ['/s', '/t', '0']).then((result) {
      print(result.stdout);
      print(result.stderr);
    });
  }

  void restartWindows() {
    // ใช้คำสั่ง restart ใน Windows
    Process.run('shutdown', ['/r', '/t', '0']).then((result) {
      print(result.stdout); // ข้อความแสดงผล
      print(result.stderr); // ข้อความข้อผิดพลาด
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                SystemNavigator.pop();
              },
              child: const Text("Exit App"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                restartWindows();
              },
              child: Text("RestartWindows"),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: () {
                shutdownWindows();
              },
              child: Text("ShutdownWindows"),
            ),
          ),
        ],
      ),
    );
  }
}
