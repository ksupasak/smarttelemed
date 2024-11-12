// ignore_for_file: use_build_context_synchronously, invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member

import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:smarttelemed/station/provider/provider.dart'; 

class PreparationVideoCall extends StatefulWidget {
  const PreparationVideoCall({super.key});

  @override
  State<PreparationVideoCall> createState() => _PreparationVideoCallState();
}

class _PreparationVideoCallState extends State<PreparationVideoCall> {
  Future<void> getPathVideo() async {
    var url =
        Uri.parse('${context.read<DataProvider>().platfromURL}/get_video');
    var res = await http
        .post(url, body: {'public_id': context.read<DataProvider>().id});
    var resTojson = json.decode(res.body);
    context.read<DataProvider>().dataVideoCall = resTojson['data'];
    context.read<DataProvider>().notifyListeners();
    setState(() {});
  }

  @override
  void initState() {
    getPathVideo();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;

    return context.read<DataProvider>().dataVideoCall == null
        ? Scaffold(
            body: Stack(
              children: [
                Positioned(
                    child: SizedBox(
                        height: height,
                        width: width,
                        child: const Text("Login"))),
                Positioned(
                  child: SizedBox(
                    height: height,
                    width: width,
                    child: Center(
                      child: SizedBox(
                        height: height * 0.06,
                        width: width,
                        child: Center(
                          child: Text(
                            'DOWNLOAD DATA VIDEO',
                            style: TextStyle(
                              fontSize: width * 0.05,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xff00A3FF),
                              shadows: const [
                                Shadow(
                                  color: Colors.grey,
                                  offset: Offset(2, 2),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        : const  Text("หน้า video call");//VideoCall();
  }
}
