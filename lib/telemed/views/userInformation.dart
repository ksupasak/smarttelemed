import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/background.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';
import 'package:smarttelemed/telemed/views/ui/informationCard.dart';

class Userinformation extends StatefulWidget {
  const Userinformation({super.key});

  @override
  State<Userinformation> createState() => _UserinformationState();
}

class _UserinformationState extends State<Userinformation> {
  String birthdate(String datas) {
    String data =
        "${datas[6]}${datas[7]}/${datas[4]}${datas[5]}/${datas[0]}${datas[1]}${datas[2]}${datas[3]}";
    return data;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.read<DataProvider>();
    return Scaffold(
      body: Stack(
        children: [
          const Background(),
          SizedBox(
            width: width,
            height: height,
            child: ListView(
              children: [
                SizedBox(height: height * 0.15),
                Center(
                  child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 0.5,
                              color: Color(0xff48B5AA),
                              offset: Offset(0, 3)),
                        ],
                      ),
                      child: const Center(
                        child: InformationCard(),
                      )),
                ),
                SizedBox(height: height * 0.02),
                Center(
                  child: Container(
                    width: width * 0.8,
                    height: height * 0.1,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: const [
                        BoxShadow(
                            blurRadius: 2,
                            spreadRadius: 2,
                            color: Color.fromARGB(255, 188, 188, 188),
                            offset: Offset(0, 2)),
                      ],
                    ),
                    child: Center(
                      child: provider.claimType != ""
                          ? Text(
                              "${provider.claimTypeName} (${provider.claimType})",
                              style: TextStyle(fontSize: width * 0.03))
                          : Text("ไม่มีสิทธิ์การรักษา ชำระค่ารักษาเอง",
                              style: TextStyle(fontSize: width * 0.03)),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.01),
                Center(
                  child: Container(
                      width: width * 0.8,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white,
                        boxShadow: const [
                          BoxShadow(
                              blurRadius: 2,
                              spreadRadius: 2,
                              color: Color.fromARGB(255, 188, 188, 188),
                              offset: Offset(0, 2)),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: Column(
                          children: [
                            Text("ตรวจสอบข้อมูล",
                                style: TextStyle(fontSize: width * 0.04)),
                            provider.vn == ""
                                ? Text(
                                    provider.text_no_vn,
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontSize: width * 0.03),
                                  )
                                : const Text(""),
                            Row(
                              children: [
                                SizedBox(
                                  width: width * 0.3,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("เลขบัตรประชาชน",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text("ชื่อ - นามสกุล",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text("วันเดือนปีเกิด",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text("HN :",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text("เบอร์โทร : ",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: width * 0.4,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(context.watch<DataProvider>().id,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(
                                          "${provider.fname}  ${provider.lname}",
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(birthdate(provider.birthdate),
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(provider.hn,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                      Text(provider.phone,
                                          style: TextStyle(
                                              fontSize: width * 0.03)),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.02)
                          ],
                        ),
                      )),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
