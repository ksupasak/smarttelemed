import 'package:flutter/material.dart';

import 'package:smarttelemed/apps/station/local/local.dart';
import 'package:smarttelemed/apps/station/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/ui/widgetdew.dart/widgetdew.dart';

class CheckQueue extends StatefulWidget {
  const CheckQueue({super.key});

  @override
  State<CheckQueue> createState() => _CheckQueueState();
}

class _CheckQueueState extends State<CheckQueue> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        const backgrund(),
        Positioned(
          child: ListView(
            children: [
              GestureDetector(
                onTap: (() {
                  addDataInfoToDatabase(DataProvider());
                }),
                child: Container(height: 200, width: 200, color: Colors.amber),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
