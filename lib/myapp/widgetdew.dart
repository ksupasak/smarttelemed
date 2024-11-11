import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/capability_profile.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/enums.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/generator.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_column.dart';
// import 'package:flutter_pos_printer_platform/esc_pos_utils_platform/src/pos_styles.dart';
// import 'package:flutter_pos_printer_platform/flutter_pos_printer_platform.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';

import 'package:just_audio/just_audio.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;
import 'package:smarttelemed/myapp/provider/provider.dart';

class backgrund extends StatefulWidget {
  const backgrund({super.key});

  @override
  State<backgrund> createState() => _backgrundState();
}

class _backgrundState extends State<backgrund> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Positioned(
        child: Container(
      width: _width,
      height: _height,
      color: Colors.white,
      child: Column(
        children: [
          Container(
            height: _height * 0.2,
            width: _width,
            child: SvgPicture.asset(
              'assets/Frame 9178.svg',
              fit: BoxFit.fill,
            ),
          ),
        ],
      ),
    )
        //      BackGroundSmart_Health(
        //   BackGroundColor: [
        //     Color.fromARGB(255, 255, 255, 255),
        //     StyleColor.backgroundbegin,
        //     StyleColor.backgroundbegin,
        //   ],
        // )
        );
  }
}

class BoxTime extends StatefulWidget {
  BoxTime({super.key});

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
  }

  void start() {
    timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        dateTime = DateTime.now();
        data = "${dateTime.hour}:" +
            "${dateTime.minute.toString().padLeft(2, '0')}:" +
            "${dateTime.second.toString().padLeft(2, '0')}";
      });
    });
  }

  void stop() {
    setState(() {
      timer?.cancel();
    });
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    return Container(
        height: _height * 0.1,
        width: _width,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                width: _width * 0.45,
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [WidgetNameHospital()],
                      ),
                      Text(context.read<DataProvider>().care_unit,
                          style: style),
                    ]),
              ),
              Container(
                  width: _width * 0.35,
                  height: _height * 0.07,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                          width: _width * 0.2,
                          height: _height * 0.03,
                          child: Row(
                            children: [
                              Text(data.toString(), style: style),
                            ],
                          )),
                    ],
                  )),
            ],
          ),
        ));
  }
}

class BoxWidetdew extends StatefulWidget {
  BoxWidetdew(
      {super.key,
      this.color,
      this.text,
      this.height,
      this.width,
      this.fontSize,
      this.textcolor,
      this.fontWeight,
      this.radius,
      this.colorborder});
  var color;
  var text;
  var width;
  var height;
  var fontSize;
  var textcolor;
  var fontWeight;
  var radius;
  var colorborder;
  @override
  State<BoxWidetdew> createState() => _BoxWidetdewState();
}

class _BoxWidetdewState extends State<BoxWidetdew> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      decoration: BoxDecoration(
        border: widget.colorborder == null
            ? null
            : Border.all(color: widget.colorborder, width: 2),
        borderRadius: widget.radius == null
            ? BorderRadius.circular(100)
            : BorderRadius.circular(widget.radius),
        color: widget.color == null ? Colors.amber : widget.color,
        boxShadow: [
          BoxShadow(
            blurRadius: 2,
            offset: Offset(0.5, 2),
            color: Colors.grey,
          ),
        ],
      ),
      height: widget.height == null ? _height * 0.02 : _height * widget.height,
      width: widget.width == null ? _width * 0.08 : _width * widget.width,
      child: Center(
        child: widget.text == null
            ? null
            : Text(
                widget.text.toString(),
                style: TextStyle(
                  fontFamily: context.read<DataProvider>().family,
                  fontSize:
                      widget.fontSize == null ? 20 : _width * widget.fontSize,
                  color: widget.textcolor == null
                      ? Colors.black
                      : widget.textcolor,
                  fontWeight: widget.fontWeight == null
                      ? FontWeight.w400
                      : widget.fontWeight,
                ),
              ),
      ),
    );
  }
}

class WidgetNameHospital extends StatefulWidget {
  const WidgetNameHospital({super.key});

  @override
  State<WidgetNameHospital> createState() => _WidgetNameHospitalState();
}

class _WidgetNameHospitalState extends State<WidgetNameHospital> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 255, 255, 255),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Container(
        child: Center(
      child: Container(
          child:
              Text(context.read<DataProvider>().name_hospital, style: style)),
    ));
  }
}

class BoxDecorate extends StatefulWidget {
  BoxDecorate({super.key, this.child, this.color});
  var child;
  var color;

  @override
  State<BoxDecorate> createState() => _BoxDecorateState();
}

class _BoxDecorateState extends State<BoxDecorate> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return widget.child == null
        ? Container()
        : Container(
            // color: Color.fromARGB(37, 227, 151, 145),
            width: _width,
            height: _height * 0.12,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                    width: _width * 0.8,
                    height: _height * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                            blurRadius: 0.5,
                            color: Color(0xff48B5AA),
                            offset: Offset(0, 3)),
                      ],
                    ),
                    child: Center(
                      child: widget.child,
                    )),
              ],
            ),
          );
  }
}

// class BoxDecorate2 extends StatefulWidget {
//   BoxDecorate2({super.key, this.child, this.color});
//   var child;
//   var color;
//   @override
//   State<BoxDecorate2> createState() => _BoxDecorate2State();
// }

// class _BoxDecorate2State extends State<BoxDecorate2> {
//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;

//     return widget.child == null
//         ? Container()
//         : Container(
//             width: _width,
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Container(
//                     width: _width * 0.8,
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(10),
//                       boxShadow: [
//                         BoxShadow(
//                             blurRadius: 1,
//                             spreadRadius: 1.5,
//                             color: Color(0xff48B5AA),
//                             offset: Offset(0, 3)),
//                       ],
//                     ),
//                     child: Center(
//                       child: widget.child,
//                     )),
//               ],
//             ),
//           );
//   }
// }

// class InformationCard extends StatefulWidget {
//   InformationCard({super.key, this.dataidcard});
//   var dataidcard;
//   @override
//   State<InformationCard> createState() => _InformationCardState();
// }

// class _InformationCardState extends State<InformationCard> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Row(
//       children: [
//         Padding(
//           padding: const EdgeInsets.all(8.0),
//           child: Container(
//               width: MediaQuery.of(context).size.height * 0.1,
//               height: MediaQuery.of(context).size.height * 0.1,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(15),
//                 color: Colors.white,
//                 boxShadow: [
//                   BoxShadow(
//                       blurRadius: 2,
//                       spreadRadius: 2,
//                       color: Color.fromARGB(255, 188, 188, 188),
//                       offset: Offset(0, 2)),
//                 ],
//               ),
//               child: ClipRRect(
//                   borderRadius: BorderRadius.circular(15),
//                   child: widget.dataidcard['personal']['picture_url'] == ''
//                       ? Container(
//                           color: Color.fromARGB(255, 240, 240, 240),
//                           child: Image.asset('assets/user (1).png'))
//                       : Image.network(
//                           '${widget.dataidcard['personal']['picture_url']}',
//                           fit: BoxFit.fill,
//                         ))),
//         ),
//         Container(
//           child: Padding(
//               padding: const EdgeInsets.all(8.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     "${widget.dataidcard['personal']['first_name']}" +
//                         '  ' +
//                         "${widget.dataidcard['personal']['last_name']}",
//                     style: TextStyle(
//                       fontFamily: context.read<DataProvider>().family,
//                       fontSize: MediaQuery.of(context).size.width * 0.035,
//                       color: Color(0xff48B5AA),
//                       shadows: [
//                         Shadow(
//                             //  color: Color.fromARGB(255, 0, 109, 64),
//                             //  blurRadius: 10,
//                             ),
//                       ],
//                     ),
//                   ),
//                   SizedBox(
//                     height: MediaQuery.of(context).size.height * 0.005,
//                   ),
//                   Text(
//                     "${widget.dataidcard['personal']['public_id']}",
//                     style: TextStyle(
//                       fontFamily: context.read<DataProvider>().family,
//                       fontSize: MediaQuery.of(context).size.width * 0.03,
//                       color: Color(0xff1B6286),
//                       shadows: [
//                         Shadow(
//                             // color: Color.fromARGB(255, 0, 109, 64),
//                             // blurRadius: 10,
//                             ),
//                       ],
//                     ),
//                   ),
//                 ],
//               )),
//         ),
//       ],
//     );
//   }
// }

class Line extends StatefulWidget {
  Line({super.key, this.height, this.width, this.color});
  var height;
  var width;
  var color;
  @override
  State<Line> createState() => _LineState();
}

class _LineState extends State<Line> {
  Color c = Colors.black;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.height == null ? 1 : widget.height,
      width: widget.width == null ? 1 : widget.width,
      color: widget.color == null ? c : widget.color,
    );
  }
}

class MarkCheck extends StatefulWidget {
  MarkCheck({super.key, this.height, this.width, this.pathicon});
  var height;
  var width;
  var pathicon;
  @override
  State<MarkCheck> createState() => _MarkCheckState();
}

class _MarkCheckState extends State<MarkCheck> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
        child: widget.pathicon == null
            ? Container(
                color: Colors.amber,
              )
            : Image.asset(
                '${widget.pathicon}',
                height: widget.height == null ? 1 : _height * widget.height,
                width: widget.width == null ? 1 : _width * widget.width,
              ));
  }
}

class BoxQueue extends StatefulWidget {
  BoxQueue({super.key});

  @override
  State<BoxQueue> createState() => _BoxQueueState();
}

class _BoxQueueState extends State<BoxQueue> {
  var resTojson;
  String? textqueue;
  bool q = false;
  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      textqueue = resTojson["queue_number"];
      if (!q) {
        Future.delayed(const Duration(seconds: 2), () {
          checkt_queue();
          setState(() {
            q = true;
          });
        });
      }
    });
  }

  @override
  void initState() {
    checkt_queue();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return resTojson != null
        ? resTojson["queue_number"] != ""
            ? Container(
                width: _width * 0.8,
                height: _height * 0.15,
                child: Column(
                  children: [
                    Text(
                      'กรุณารอเรียกคิว',
                      style: TextStyle(
                          fontFamily: context.read<DataProvider>().family,
                          fontSize: _width * 0.04),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          color: Color.fromARGB(149, 18, 42, 253),
                          borderRadius: BorderRadius.circular(20)),
                      width: _width * 0.8,
                      height: _height * 0.10,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.blue,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: 'หมายเลขคิวของคุณ',
                                textcolor: Colors.white,
                              ),
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.white,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: textqueue,
                                textcolor: Color.fromARGB(255, 43, 179, 161),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.blue,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: 'รออีก(คิว)',
                                textcolor: Colors.white,
                              ),
                              BoxWidetdew(
                                width: 0.39,
                                height: 0.045,
                                color: Colors.white,
                                radius: 10.0,
                                fontSize: 0.025,
                                text: resTojson['wait_list'].length.toString(),
                                textcolor: Colors.blue,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              )
            : Container(
                child: Text(resTojson["queue_number"]),
              )
        : Container(
            width: MediaQuery.of(context).size.width * 0.07,
            height: MediaQuery.of(context).size.width * 0.07,
            child: CircularProgressIndicator(),
          );
  }
}

class BoxShoHealth_Records extends StatefulWidget {
  BoxShoHealth_Records({super.key});

  @override
  State<BoxShoHealth_Records> createState() => _BoxShoHealth_RecordsState();
}

class _BoxShoHealth_RecordsState extends State<BoxShoHealth_Records> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
      print(resTojson);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Colors.white,
        fontSize: _width * 0.04);
    TextStyle styletext2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.03);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
    TextStyle styletext5 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 12, 172, 153),
        fontSize: _width * 0.025);
    return Container(
      width: _width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text('ข้อมูลสุขภาพ', style: styletext3),
          Container(
            color: Color.fromARGB(255, 95, 182, 167),
            height: _height * 0.04,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                BoxDataHealth(child: Text('วันที่', style: styletext)),
                BoxDataHealth(child: Text('height', style: styletext)),
                BoxDataHealth(child: Text('weight', style: styletext)),
                BoxDataHealth(child: Text('temp', style: styletext)),
                BoxDataHealth(child: Text('sys.', style: styletext)),
                BoxDataHealth(child: Text('dia', style: styletext)),
                BoxDataHealth(child: Text('spo2', style: styletext)),
                // Text('fbs', style: styletext),
                // Text('si', style: styletext),
                // Text('uric', style: styletext),
                // Text('pulse_rate.', style: styletext),
              ],
            ),
          ),
          resTojson != null
              ? resTojson['health_records'].length != 0
                  ? Container(
                      height: _height * 0.35,
                      child: ListView.builder(
                        itemCount: resTojson['health_records'].length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              print(index);
                            },
                            child: Column(
                              children: [
                                Container(height: 1, color: Colors.white),
                                Container(
                                  color: Color.fromARGB(255, 219, 246, 240),
                                  height: _height * 0.05,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      resTojson['health_records'][index]
                                                  ['updated_at'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['updated_at']}',
                                                  style: styletext5)),
                                      resTojson['health_records'][index]
                                                  ['height'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['height']}',
                                                  style: styletext2)),
                                      resTojson['health_records'][index]
                                                  ['weight'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['weight']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['temp'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['temp']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_dia'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_dia']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['bp_sys'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['bp_sys']}',
                                                  style: styletext2),
                                            ),
                                      resTojson['health_records'][index]
                                                  ['spo2'] ==
                                              null
                                          ? BoxDataHealth(child: Text(' - '))
                                          : BoxDataHealth(
                                              child: Text(
                                                  '${resTojson['health_records'][index]['spo2']}',
                                                  style: styletext2),
                                            ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ))
                  : Container(
                      height: _height * 0.04,
                      color: Color.fromARGB(100, 255, 255, 255),
                      child: Center(
                          child: Text('ไม่มีข้อมูลสุขภาพ', style: styletext4)),
                    )
              : Container()
        ],
      ),
    );
  }
}

class BoxDataHealth extends StatefulWidget {
  BoxDataHealth({super.key, required this.child});
  Widget child;
  @override
  State<BoxDataHealth> createState() => _BoxDataHealthState();
}

class _BoxDataHealthState extends State<BoxDataHealth> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      width: _width * 0.14,
      child: Center(child: widget.child),
    );
  }
}

class BoxRunQueue2 extends StatefulWidget {
  const BoxRunQueue2({super.key});

  @override
  State<BoxRunQueue2> createState() => _BoxRunQueue2State();
}

class _BoxRunQueue2State extends State<BoxRunQueue2> {
  Timer? _timer;
  var resTojson;
  bool loadplatfromURL = false;
  Future<void> get_queue() async {
    try {
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
      });
      setState(() {
        resTojson = json.decode(res.body);
      });
    } catch (e) {
      _timer!.cancel();
      loadplatfromURL = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'platfromURL ไม่ถูหต้อง',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL != '') {
          get_queue();
        }
      });
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    lop_queue();
    // TODO: implement initState
    super.initState();
  }

  BoxDecoration boxdecoration_head_blue = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff00a3ff),
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_head_yellow = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xffffa800),
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_head_grey = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Colors.grey,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 1.5),
            blurRadius: 1,
            spreadRadius: 1)
      ]);
  BoxDecoration boxdecoration_box = BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.white, // context.read<StyleColorsApp>().blue_app,
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 0)
      ]);
  BoxDecoration boxdecoration_boxbutton = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xff31d6aa),
      boxShadow: [
        BoxShadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 1,
            spreadRadius: 2)
      ]);
  BoxDecoration boxdecoration_boxbutton_in = BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      color: Color(0xffffffff),
      border: Border.all(color: Colors.grey));

  Widget status() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().family);
    return Container(
      height: _height * 0.08,
      child: Container(
        decoration: resTojson != null
            ? resTojson['message'] == 'no queue'
                ? resTojson['completes'].length != 0
                    ? boxdecoration_head_yellow
                    : boxdecoration_head_grey
                : resTojson['message'] == 'calling'
                    ? boxdecoration_head_blue
                    : boxdecoration_head_blue
            : boxdecoration_head_grey,
        height: _height * 0.08,
        width: _width * 0.68,
        child: Center(
            child: resTojson != null
                ? resTojson['message'] == 'no queue'
                    ? resTojson['completes'].length != 0
                        ? Text('รอรับผลตรวจ', style: style)
                        : Text('ยังไม่เรียก', style: style)
                    : resTojson['message'] == 'calling'
                        ? Text('เรียกคิว', style: style)
                        : Text('?', style: style)
                : Text(
                    "--",
                    style: style,
                  )),
      ),
    );
  }

  Widget numberqueue() {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Color(0xffffa800),
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().family);
    TextStyle style2 = TextStyle(
        color: Colors.grey,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().family);
    return Center(
        child: resTojson != null
            ? resTojson['message'] == 'no queue'
                ? resTojson['completes'].length != 0
                    ? Text(resTojson['completes'][0], style: style)
                    : Text('--', style: style2)
                : resTojson['message'] == 'calling'
                    ? Text(resTojson['queue_number'], style: style)
                    : Text(resTojson['queue_number'], style: style)
            : Text(
                "--",
                style: style2,
              ));
  }

  Widget listQ() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, 2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? resTojson['waits'].length != 0
            ? ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: resTojson['waits'].length,
                itemBuilder: (context, index) {
                  return Container(
                    width: _width * 0.08,
                    decoration: decoration,
                    margin: EdgeInsets.all(8),
                    child: Center(
                      child: Text(
                        resTojson['waits'][index],
                        style: TextStyle(color: Color(0xff1B6286)),
                      ),
                    ),
                  );
                },
              )
            : Container(
                width: _width * 0.08,
                child: Center(
                  child: Text(
                    '- -',
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              )
        : Container();
  }

  Widget calleds() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, 2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['calleds'].length,
            itemBuilder: (context, index) {
              return Container(
                decoration: decoration,
                width: _width * 0.08,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['calleds'][index],
                    style: TextStyle(color: Color(0xff1B6286)),
                  ),
                ),
              );
            },
          )
        : SizedBox();
  }

  Widget completes() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, 2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['completes'].length,
            itemBuilder: (context, index) {
              return Container(
                decoration: decoration,
                width: _width * 0.08,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['completes'][index],
                    style: TextStyle(color: Color(0xff1B6286)),
                  ),
                ),
              );
            },
          )
        : SizedBox();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    TextStyle style = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.06,
        fontFamily: context.read<DataProvider>().family);
    TextStyle style2 = TextStyle(
        color: Color(0xffffa800),
        fontSize: _width * 0.03,
        fontFamily: context.read<DataProvider>().family);
    TextStyle style3 = TextStyle(
        color: Colors.white,
        fontSize: _width * 0.03,
        fontFamily: context.read<DataProvider>().family);
    TextStyle style4 = TextStyle(
        color: Color(0xff1B6286),
        fontSize: _width * 0.03,
        fontFamily: context.read<DataProvider>().family);
    BoxDecoration boxdecoration_text_queue_blue = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xff00a3ff),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0.5),
              blurRadius: 2,
              spreadRadius: 0)
        ]);
    BoxDecoration boxdecoration_text_queue_green = BoxDecoration(
        //Color(0xffFFA800),
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffcccccc),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0.5),
              blurRadius: 2,
              spreadRadius: 0)
        ]);
    BoxDecoration boxdecoration_text_queue_completes = BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Color(0xffFFA800),
        boxShadow: [
          BoxShadow(
              color: Colors.black,
              offset: Offset(0, 0.5),
              blurRadius: 2,
              spreadRadius: 0)
        ]);
    BoxDecoration boxdecoration_box2 = BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white, // context.read<StyleColorsApp>().blue_app,
        boxShadow: [
          BoxShadow(
              color: Colors.grey,
              offset: Offset(0, 2),
              blurRadius: 1,
              spreadRadius: 0)
        ]);
    BoxDecoration boxdecoration_box3 = BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: Color(0xff31D6AA),
    );
    BoxDecoration boxdecoration_box4 = BoxDecoration(
      borderRadius: BorderRadius.only(
          topRight: Radius.circular(10), topLeft: Radius.circular(10)),
      color: Color(0xff00A3FF),
    );
    return Container(
      child: Center(
        child: Column(
          children: [
            Container(
              height: _height * 0.2,
              width: _width * 0.95,
              decoration: boxdecoration_box,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(children: [
                  Container(
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Container(
                            decoration: boxdecoration_box,
                            child: Column(
                              children: [
                                Container(
                                  height: _height * 0.05,
                                  width: _width * 0.4,
                                  decoration: boxdecoration_box3,
                                  child: Center(
                                      child: Text('เเพทย์', style: style3)),
                                ),
                                resTojson != null
                                    ? Container(
                                        height: _height * 0.04,
                                        width: _width * 0.4,
                                        child: ListView.builder(
                                          itemCount:
                                              resTojson['callings'].length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: _width * 0.42,
                                              height: _height * 0.04,
                                              child: Center(
                                                child: Text(
                                                    resTojson['callings'][index]
                                                        ['doctor_name'],
                                                    style: style2),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          Container(
                            decoration: boxdecoration_box,
                            child: Column(
                              children: [
                                Container(
                                  height: _height * 0.05,
                                  width: _width * 0.22,
                                  decoration: boxdecoration_box3,
                                  child: Center(
                                      child: Text('คิวที่', style: style3)),
                                ),
                                resTojson != null
                                    ? Container(
                                        height: _height * 0.04,
                                        width: _width * 0.22,
                                        child: ListView.builder(
                                          itemCount:
                                              resTojson['callings'].length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: _width * 0.22,
                                              height: _height * 0.04,
                                              child: Center(
                                                child: Text(
                                                    resTojson['callings'][index]
                                                        ['queue_number'],
                                                    style: style2),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                          Container(
                            decoration: boxdecoration_box,
                            child: Column(
                              children: [
                                Container(
                                  height: _height * 0.05,
                                  width: _width * 0.22,
                                  decoration: boxdecoration_box4,
                                  child: Center(
                                      child: Text('สถานะ', style: style3)),
                                ),
                                resTojson != null
                                    ? Container(
                                        height: _height * 0.04,
                                        width: _width * 0.22,
                                        child: ListView.builder(
                                          itemCount:
                                              resTojson['callings'].length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              width: _width * 0.42,
                                              height: _height * 0.04,
                                              child: Center(
                                                child: Text('เรียกคิว',
                                                    style: style2),
                                              ),
                                            );
                                          },
                                        ),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ]),
                  ),
                  SizedBox(height: _height * 0.01),
                  resTojson != null
                      ? resTojson['processings'].length != 0
                          ? Container(
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Container(
                                      decoration: boxdecoration_box,
                                      child: Column(
                                        children: [
                                          resTojson != null
                                              ? Container(
                                                  height: _height * 0.04,
                                                  width: _width * 0.42,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        resTojson['processings']
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        width: _width * 0.42,
                                                        height: _height * 0.04,
                                                        child: Center(
                                                          child: Text(
                                                              resTojson['processings']
                                                                      [index][
                                                                  'doctor_name'],
                                                              style: style4),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: boxdecoration_box,
                                      child: Column(
                                        children: [
                                          resTojson != null
                                              ? Container(
                                                  height: _height * 0.04,
                                                  width: _width * 0.22,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        resTojson['processings']
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        width: _width * 0.22,
                                                        height: _height * 0.04,
                                                        child: Center(
                                                          child: Text(
                                                              resTojson['processings']
                                                                      [index][
                                                                  'queue_number'],
                                                              style: style4),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                    Container(
                                      decoration: boxdecoration_box,
                                      child: Column(
                                        children: [
                                          resTojson != null
                                              ? Container(
                                                  height: _height * 0.04,
                                                  width: _width * 0.22,
                                                  child: ListView.builder(
                                                    itemCount:
                                                        resTojson['processings']
                                                            .length,
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Container(
                                                        width: _width * 0.42,
                                                        height: _height * 0.04,
                                                        child: Center(
                                                          child: Text(
                                                              'เข้าตรวจ',
                                                              style: style4),
                                                        ),
                                                      );
                                                    },
                                                  ),
                                                )
                                              : Container()
                                        ],
                                      ),
                                    ),
                                  ]),
                            )
                          : Container()
                      : Container(),
                ]),
              ),
            ),
            SizedBox(height: _height * 0.01),
            Container(
              width: _width,
              child: Center(
                child: Container(
                  decoration: boxdecoration_box,
                  width: _width * 0.6,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Container(
                          child: Row(
                            children: [
                              Container(
                                height: _height * 0.038,
                                width: _width * 0.15,
                                decoration: boxdecoration_text_queue_blue,
                                child: Center(
                                    child: Text('คิวต่อไป', style: style3)),
                              ),
                              Container(
                                height: _height * 0.04,
                                width: _width * 0.38,
                                child: listQ(),
                              )
                            ],
                          ),
                        ),
                        resTojson != null
                            ? resTojson['completes'].length != 0
                                ? Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: _height * 0.038,
                                          width: _width * 0.15,
                                          decoration:
                                              boxdecoration_text_queue_completes,
                                          child: Center(
                                              child: Text('รับผลตรวจ',
                                                  style: style3)),
                                        ),
                                        Container(
                                          height: _height * 0.04,
                                          width: _width * 0.38,
                                          child: completes(),
                                        )
                                      ],
                                    ),
                                  )
                                : Container()
                            : Container(),
                        resTojson != null
                            ? resTojson['calleds'].length != 0
                                ? Container(
                                    child: Row(
                                      children: [
                                        Container(
                                          height: _height * 0.038,
                                          width: _width * 0.15,
                                          decoration:
                                              boxdecoration_text_queue_green,
                                          child: Center(
                                              child: Text('เรียกเเล้ว',
                                                  style: style3)),
                                        ),
                                        Container(
                                          height: _height * 0.04,
                                          width: _width * 0.38,
                                          child: calleds(),
                                        )
                                      ],
                                    ),
                                  )
                                : Container()
                            : Container(),
                      ],
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BoxRunQueue extends StatefulWidget {
  const BoxRunQueue({super.key});

  @override
  State<BoxRunQueue> createState() => _BoxRunQueueState();
}

class _BoxRunQueueState extends State<BoxRunQueue> {
  Timer? _timer;
  var resTojson;
  bool loadplatfromURL = false;
  Future<void> get_queue() async {
    try {
      var url = Uri.parse('${context.read<DataProvider>().platfromURL}/list_q');
      var res = await http.post(url, body: {
        'care_unit_id': context.read<DataProvider>().care_unit_id,
      });
      setState(() {
        resTojson = json.decode(res.body);
      });
    } catch (e) {
      _timer!.cancel();
      loadplatfromURL = true;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'platfromURL ไม่ถูหต้อง',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void lop_queue() {
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        if (context.read<DataProvider>().platfromURL != '') {
          get_queue();
        }
      });
    });
  }

  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  void initState() {
    lop_queue();
    // TODO: implement initState
    super.initState();
  }

  Widget Q() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontSize: _width * 0.035,
        fontFamily: context.read<DataProvider>().family,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    TextStyle style2 = TextStyle(
        fontSize: _width * 0.025,
        fontFamily: context.read<DataProvider>().family,
        fontWeight: FontWeight.w600,
        color: Colors.white);
    return resTojson != null
        ? resTojson['message'] == 'no queue'
            ? resTojson['completes'].length != 0
                ? Container(
                    width: _width * 0.7,
                    height: _height * 0.08,
                    child: Row(children: [
                      Container(
                        width: _width * 0.4,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: resTojson['completes'].length,
                          itemBuilder: (context, index) {
                            return Container(
                              width: _width * 0.1,
                              height: _height * 0.01,
                              margin: EdgeInsets.all(8),
                              child: Center(
                                child: Text(
                                  resTojson['completes'][index],
                                  style: style2,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                          width: _width * 0.3,
                          child: Center(
                              child: Text('กรุณารับผลตรวจ', style: style)))
                    ]))
                : Center(
                    child: Container(
                      width: _width * 0.7,
                      child: Center(child: Text("ยังไม่เรียก", style: style)),
                    ),
                  )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: _width * 0.4,
                    child: Center(
                        child:
                            Text("${resTojson['queue_number']}", style: style)),
                  ),
                  Container(
                    width: _width * 0.3,
                    child: resTojson != null
                        ? resTojson['message'] == 'calling'
                            ? Text('เรียกตรวจ', style: style)
                            : resTojson['message'] == 'processing'
                                ? Text('กำลังตรวจ', style: style)
                                : Text(resTojson['message'])
                        : Text(''),
                  )
                ],
              )
        : loadplatfromURL == true
            ? Container(
                child: Center(
                    child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                      width: MediaQuery.of(context).size.width * 0.05,
                      height: MediaQuery.of(context).size.width * 0.05,
                      child: CircularProgressIndicator(
                        color: Colors.red,
                      )),
                  Text('platfromURL ไม่ถูหต้อง')
                ],
              )))
            : Container();
  }

  Widget listQ() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, -2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return resTojson != null
        ? ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: resTojson['waits'].length,
            itemBuilder: (context, index) {
              return Container(
                width: _width * 0.08,
                decoration: decoration,
                margin: EdgeInsets.all(8),
                child: Center(
                  child: Text(
                    resTojson['waits'][index],
                    style: TextStyle(color: Colors.green),
                  ),
                ),
              );
            },
          )
        : Container();
  }

  Widget calleds() {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    Decoration decoration = BoxDecoration(boxShadow: [
      BoxShadow(
          color: Color.fromARGB(255, 157, 157, 157),
          offset: Offset(0, -2),
          blurRadius: 2)
    ], color: Colors.white, borderRadius: BorderRadius.circular(5));
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: resTojson['calleds'].length,
      itemBuilder: (context, index) {
        return Container(
          decoration: decoration,
          width: _width * 0.08,
          margin: EdgeInsets.all(8),
          child: Center(
            child: Text(
              resTojson['calleds'][index],
              style: TextStyle(color: Colors.green),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    BoxDecoration boxDecoration = BoxDecoration(
      //  color: Color.fromARGB(255, 221, 221, 221),
      borderRadius: BorderRadius.circular(10),
    );
    BoxDecoration boxDecoration2 = BoxDecoration(
      color: resTojson != null
          ? resTojson['message'] == 'no queue'
              ? resTojson['completes'].length != 0
                  ? Colors.green
                  : Color.fromARGB(255, 175, 175, 175)
              : resTojson['message'] == 'processing'
                  ? Colors.blue
                  : Colors.yellow
          : Color.fromARGB(255, 175, 175, 175),
      borderRadius: BorderRadius.circular(10),
    );
    TextStyle style = TextStyle(
        fontSize: _width * 0.015,
        fontFamily: context.read<DataProvider>().family,
        fontWeight: FontWeight.w600,
        color: Color.fromARGB(255, 0, 98, 82));
    return Container(
        child: Container(
      width: _width * 0.7,
      decoration: boxDecoration,
      child: Column(
        children: [
          resTojson != null
              ? resTojson['waits'].length != 0
                  ? Container(
                      width: _width * 0.7,
                      height: _height * 0.05,
                      child: Row(
                        children: [
                          Container(
                              width: _width * 0.1,
                              child:
                                  Center(child: Text('กำลังรอ', style: style))),
                          Container(width: _width * 0.6, child: listQ()),
                        ],
                      ))
                  : Container()
              : Container(),
          Container(
              width: _width * 0.7,
              height: _height * 0.08,
              decoration: boxDecoration2,
              child: Q()),
          resTojson != null
              ? resTojson['calleds'].length != 0
                  ? Container(
                      width: _width * 0.7,
                      height: _height * 0.05,
                      child: Row(
                        children: [
                          Container(
                              width: _width * 0.1,
                              child: Text('คิวที่ถูกข้าม')),
                          Container(width: _width * 0.6, child: calleds()),
                        ],
                      ))
                  : Container()
              : Container()
        ],
      ),
    ));
  }
}

class HeadBoxAppointments extends StatefulWidget {
  const HeadBoxAppointments({super.key});

  @override
  State<HeadBoxAppointments> createState() => _HeadBoxAppointmentsState();
}

class _HeadBoxAppointmentsState extends State<HeadBoxAppointments> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    return Container(
      child: Column(
        children: [
          Text("การนัดหมายครั้งถัดไป", style: style),
          Container(
            color: Color.fromARGB(255, 115, 250, 221),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('วันที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เวลา', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('สถานที่', style: style2))),
                Container(
                    width: _width * 0.25,
                    child: Center(child: Text('เเพทย์', style: style2))),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class BoxAppointments extends StatefulWidget {
  BoxAppointments({
    super.key,
  });

  @override
  State<BoxAppointments> createState() => _BoxAppointmentsState();
}

class _BoxAppointmentsState extends State<BoxAppointments> {
  var resTojson;
  void information() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    information();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    return Container(
        width: _width,
        child: Column(
          children: [
            Container(
              height: _height * 0.38,
              child: resTojson != null
                  ? resTojson['appointments'].length != 0
                      ? ListView.builder(
                          itemCount: resTojson['appointments'].length,
                          itemBuilder: (BuildContext context, int index) {
                            return GestureDetector(
                              onTap: () {
                                print(index);
                              },
                              child: Container(
                                color: Color.fromARGB(255, 219, 246, 240),
                                height: _height * 0.04,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['date'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['slot'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['care_name'],
                                                style: style))),
                                    Container(
                                        width: _width * 0.2,
                                        child: Center(
                                            child: Text(
                                                resTojson['appointments'][index]
                                                    ['doctor_name'],
                                                style: style))),
                                  ],
                                ),
                              ),
                            );
                          },
                        )
                      : Container(
                          child: Column(children: [
                          Container(
                              width: _height,
                              height: _height * 0.04,
                              color: Color.fromARGB(100, 255, 255, 255),
                              child: Center(
                                  child: Text('ไม่มีรายการ', style: style)))
                        ]))
                  : Container(),
            ),
            SizedBox(
              height: _height * 0.01,
            ),
            ButtonAddAppointToday()
          ],
        ));
  }
}

class BoxButtonVideoCall extends StatefulWidget {
  BoxButtonVideoCall({
    super.key,
  });

  @override
  State<BoxButtonVideoCall> createState() => _BoxButtonVideoCallState();
}

class _BoxButtonVideoCallState extends State<BoxButtonVideoCall> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => ConnectPage()));
      },
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
              width: 5,
              color: Colors.green,
            ),
            borderRadius: BorderRadius.circular(50)),
        child: BoxWidetdew(
          height: 0.05,
          width: 0.4,
          radius: 20.0,
          color: Color.fromARGB(80, 91, 223, 95),
          text: 'video call',
          textcolor: Colors.white,
        ),
      ),
    );
  }
}

class BoxSetting extends StatefulWidget {
  BoxSetting({super.key, this.text, this.textstyle});
  String? text;
  TextStyle? textstyle;
  @override
  State<BoxSetting> createState() => _BoxSettingState();
}

class _BoxSettingState extends State<BoxSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 20, 142, 130),
        fontSize: _width * 0.04,
        fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        width: _width * 0.98,
        height: _height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Color.fromARGB(255, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                // offset: Offset(5, 5), //(ตามเเนวx,ตามเเนวy)
                // spreadRadius: 0.0, //ขนาด เพิ่มจากเดิม
                blurRadius: 5.0, //การกระจายของสี พื้นหลัง
                color: Color.fromARGB(255, 63, 86, 83),
              )
            ]),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              GestureDetector(
                  onTap: () {},
                  child: Container(
                    width: _width * 0.98,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                            width: _width * 0.47,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.text == null
                                      ? Center(child: Text(''))
                                      : Center(
                                          child: Text(
                                            widget.text.toString(),
                                            style: widget.textstyle == null
                                                ? style1
                                                : widget.textstyle,
                                          ),
                                        ),
                                ],
                              ),
                            )),
                        Container(
                            width: _width * 0.45,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Icon(Icons.navigate_next_outlined,
                                    color: Color.fromARGB(255, 20, 142, 130)),
                              ],
                            ))
                      ],
                    ),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}

class BoxTextFieldSetting extends StatefulWidget {
  BoxTextFieldSetting(
      {super.key,
      this.keyvavlue,
      this.texthead,
      this.textinputtype,
      this.lengthlimitingtextinputformatter});
  var keyvavlue;
  String? texthead;
  TextInputType? textinputtype;
  int? lengthlimitingtextinputformatter;
  @override
  State<BoxTextFieldSetting> createState() => _BoxTextFieldSettingState();
}

class _BoxTextFieldSettingState extends State<BoxTextFieldSetting> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 19, 100, 92));
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.05,
        color: Color.fromARGB(255, 0, 0, 0));

    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.texthead == null
                  ? Text('')
                  : Text(widget.texthead.toString(), style: style1),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [BoxShadow()],
                    border: Border.all(
                        color: Color.fromARGB(255, 0, 85, 71), width: 2),
                    borderRadius: BorderRadius.circular(5)),
                width: _width * 0.9,
                child: TextField(
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: InputBorder.none,
                    ),
                    keyboardType: widget.textinputtype,
                    controller: widget.keyvavlue,
                    inputFormatters:
                        widget.lengthlimitingtextinputformatter == null
                            ? []
                            : [
                                LengthLimitingTextInputFormatter(
                                    widget.lengthlimitingtextinputformatter),
                              ],
                    style: style2),
              ),
            ]),
      ),
    );
  }
}

class BoxText extends StatefulWidget {
  BoxText({super.key, this.text});
  String? text;
  @override
  State<BoxText> createState() => _BoxTextState();
}

class _BoxTextState extends State<BoxText> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
      shadows: [
        Shadow(
          color: Color(0x80000000),
          offset: Offset(0, 2),
          blurRadius: 2,
        ),
      ],
      fontFamily: context.read<DataProvider>().family,
      fontSize: _width * 0.035,
      color: Color(0xff00A3FF),
    );
    return widget.text == null
        ? Text('')
        : Center(
            child: Text(
              widget.text.toString(),
              style: style,
            ),
          );
  }
}

class BoxToDay extends StatefulWidget {
  const BoxToDay({super.key});

  @override
  State<BoxToDay> createState() => _BoxToDayState();
}

class _BoxToDayState extends State<BoxToDay> {
  var resTojson;
  bool ontap = false;
  Future<void> checkt_queue() async {
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'care_unit_id': context.read<DataProvider>().care_unit_id,
      'public_id': context.read<DataProvider>().id,
    });
    setState(() {
      resTojson = json.decode(res.body);
    });
  }

  @override
  void initState() {
    checkt_queue();

    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle styletext = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Colors.green,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    TextStyle styletext2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color(0xff00A3FF),
        shadows: [
          Shadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        fontSize: _width * 0.05);
    TextStyle styletext5 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color(0xff31D6AA),
        shadows: [
          Shadow(
            color: Colors.grey,
            offset: Offset(0, 2),
            blurRadius: 4,
          ),
        ],
        fontSize: _width * 0.05);
    TextStyle styletext3 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 39, 0, 129),
        fontSize: _width * 0.035,
        fontWeight: FontWeight.w600);
    TextStyle styletext4 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 28, 1, 91),
        fontSize: _width * 0.03);
    TextStyle style = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.035,
        fontWeight: FontWeight.w800);
    TextStyle style2 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Color.fromARGB(255, 0, 73, 129),
        fontSize: _width * 0.045,
        fontWeight: FontWeight.w600);
    TextStyle style3 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Colors.grey,
        fontSize: _width * 0.02,
        fontWeight: FontWeight.w600);
    TextStyle style4 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        color: Colors.grey,
        fontSize: _width * 0.03,
        fontWeight: FontWeight.w600);
    TextStyle style5 = TextStyle(
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.03,
        color: Colors.grey);
    return Container(
        width: _width,
        child: resTojson != null
            ? resTojson['todays'].length != 0
                ? resTojson['queue_number'] != ''
                    ? Center(
                        child: Column(
                          children: [
                            Container(
                              height: _height * 0.28,
                              width: _width * 0.6,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                        color: Colors.grey,
                                        offset: Offset(0, 2),
                                        blurRadius: 2,
                                        spreadRadius: 1)
                                  ],
                                  borderRadius: BorderRadius.circular(15),
                                  border: Border.all(
                                      width: 5, color: Color(0xff31D6AA))),
                              child: Column(children: [
                                Container(
                                  child: Column(children: [
                                    Text(
                                      context
                                          .read<DataProvider>()
                                          .name_hospital,
                                      style: style5,
                                    ),
                                    Text(
                                      'หมายเลขคิวที่',
                                      style: TextStyle(
                                          fontFamily: context
                                              .read<DataProvider>()
                                              .family,
                                          fontWeight: FontWeight.w500,
                                          fontSize: _width * 0.03,
                                          color: Colors.black),
                                    ),
                                    Text(resTojson['queue_number'],
                                        style: TextStyle(
                                            fontFamily: context
                                                .read<DataProvider>()
                                                .family,
                                            fontWeight: FontWeight.w500,
                                            fontSize: _width * 0.04,
                                            color: Colors.black))
                                  ]),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Container(
                                    child: Row(
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text('Doctor :', style: style4),
                                            Text('Care    :', style: style4)
                                          ],
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                                "${resTojson['todays'][0]['doctor_name']} ",
                                                style: style4),
                                            Text(
                                                "${resTojson['todays'][0]['care_name']} / ${resTojson['todays'][0]['slot']}",
                                                style: style4)
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: _height * 0.01),
                                Container(
                                  width: _width * 0.6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      Text('height', style: style4),
                                      Text('weight', style: style4),
                                      Text('temp', style: style4),
                                      Text('sys', style: style4),
                                      Text('dia', style: style4),
                                      Text('spo2', style: style4),
                                    ],
                                  ),
                                ),
                                Container(
                                  width: _width * 0.6,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      resTojson['health_records'][0]
                                                  ['height'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['height']}",
                                              style: style4),
                                      resTojson['health_records'][0]
                                                  ['weight'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['weight']}",
                                              style: style4),
                                      resTojson['health_records'][0]['temp'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['temp']}",
                                              style: style4),
                                      resTojson['health_records'][0]
                                                  ['bp_sys'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['bp_sys']}",
                                              style: style4),
                                      resTojson['health_records'][0]
                                                  ['bp_dia'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['bp_dia']}",
                                              style: style4),
                                      resTojson['health_records'][0]['spo2'] ==
                                              null
                                          ? Text('-')
                                          : Text(
                                              "${resTojson['health_records'][0]['spo2']}",
                                              style: style4),
                                    ],
                                  ),
                                )
                              ]),
                            ),
                            SizedBox(height: _height * 0.01),
                            //  ButtonPrintQueue()
                          ],
                        ),
                      )
                    : Container(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                height: _width * 0.2,
                                width: _width * 0.2,
                                child: Image.asset(
                                  'assets/sdbz.png',
                                  fit: BoxFit.fill,
                                ),
                              ),
                              Text('ท่านมีกำหนดนัดหมายวันนี้',
                                  style: styletext5),
                              SizedBox(height: _height * 0.005),
                              Container(
                                //   height: _height * 0.07,
                                width: _width * 0.5,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                          color: Colors.grey,
                                          offset: Offset(0, 2),
                                          blurRadius: 2,
                                          spreadRadius: 1)
                                    ],
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                        width: 5, color: Color(0xff31D6AA))),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Row(children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text('Doctor :', style: style3),
                                        Text('Date   :', style: style3),
                                        Text('Care   :', style: style3)
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                            resTojson['todays'][0]
                                                ['doctor_name'],
                                            style: style3),
                                        Text(resTojson['todays'][0]['date'],
                                            style: style3),
                                        Text(
                                            "${resTojson['todays'][0]['care_name']}[${resTojson['todays'][0]['slot']}]",
                                            style: style3),
                                      ],
                                    )
                                  ]),
                                ),
                              ),
                              SizedBox(height: _height * 0.005),
                              // ontap == false
                              //     ? GestureDetector(
                              //         onTap: () {
                              //           setState(() {
                              //             ontap = true;
                              //           });
                              //         },
                              //         child: ButtonQueue())
                              //     : Container(
                              //         height: 0.06,
                              //         width: 0.35,
                              //         child: CircularProgressIndicator()),
                            ],
                          ),
                        ),
                      )
                : Container(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: _width * 0.2,
                            width: _width * 0.2,
                            child: SvgPicture.asset(
                              'assets/hlsg.svg',
                              fit: BoxFit.fill,
                            ),
                          ),
                          Text('วันนี้ท่านไม่มีกำหนดนัดหมาย',
                              style: styletext2),
                          SizedBox(
                            height: _height * 0.01,
                          ),
                          ButtonAddAppointToday()
                        ],
                      ),
                    ),
                  )
            : Container());
  }
}

// class ButtonPrintQueue extends StatefulWidget {
//   const ButtonPrintQueue({super.key});

//   @override
//   State<ButtonPrintQueue> createState() => _ButtonPrintQueueState();
// }

// class _ButtonPrintQueueState extends State<ButtonPrintQueue> {
//   var resTojson;
//   DateTime dateTime = DateTime.parse('0000-00-00 00:00');
//   String datatime = "";
//   ESMPrinter? printer;
//   var devices = <BluetoothPrinter>[];
//   List default_deivces = [];
//   BluetoothPrinter? selectedPrinter;
//   String height = '';
//   String weight = '';
//   String temp = '';
//   String bp_sys = '';
//   String bp_dia = '';
//   String spo2 = '';
//   bool ontap = false;

//   Future<void> checkt_queue() async {
//     var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
//     var res = await http.post(url, body: {
//       'care_unit_id': context.read<DataProvider>().care_unit_id,
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       resTojson = json.decode(res.body);
//       print(resTojson);
//       Deviceprint();
//     });
//   }

//   void selectDevice(BluetoothPrinter device) async {
//     if (selectedPrinter != null) {
//       if ((device.address != selectedPrinter!.address) ||
//           (device.typePrinter == PrinterType.usb &&
//               selectedPrinter!.vendorId != device.vendorId)) {
//         await PrinterManager.instance
//             .disconnect(type: selectedPrinter!.typePrinter);
//       }
//     }

//     selectedPrinter = device;
//     // setState(() {});
//   }

//   void Deviceprint() {
//     debugPrint('call print test');

//     debugPrint("selectedPrinter = ${selectedPrinter}");
//     print("selectedPrinter = ${selectedPrinter}");
//     if (selectedPrinter == null) {
//       for (final device in devices) {
//         var vendor_id = device.vendorId;
//         var product_id = device.productId;
//         debugPrint('scan for ${vendor_id} ${product_id}');
//         if (default_deivces != null) {
//           for (final s in default_deivces) {
//             if (s['vendor_id'] == vendor_id && s['product_id'] == product_id) {
//               debugPrint('found ');
//               selectDevice(device);
//             }
//           }
//         }
//       }
//     }
//     debugPrint("selectDevice = ${selectDevice}");
//     print("selectDevice = ${selectDevice}");
//     if (selectDevice != null) {
//       print('resTojson = ${resTojson['health_records'].length}');
//       if (resTojson['health_records'].length != 0) {
//         setState(() {
//           resTojson['health_records'][0]['height'] == null
//               ? height = ''
//               : height = resTojson['health_records'][0]['height'];
//           resTojson['health_records'][0]['weight'] == null
//               ? weight = ''
//               : weight = resTojson['health_records'][0]['weight'];
//           resTojson['health_records'][0]['temp'] == null
//               ? temp = ''
//               : temp = resTojson['health_records'][0]['temp'];
//           resTojson['health_records'][0]['bp_sys'] == null
//               ? bp_sys = ''
//               : bp_sys = resTojson['health_records'][0]['bp_sys'];
//           resTojson['health_records'][0]['bp_dia'] == null
//               ? bp_dia = ''
//               : bp_dia = resTojson['health_records'][0]['bp_dia'];
//           resTojson['health_records'][0]['spo2'] == null
//               ? spo2 = ''
//               : spo2 = resTojson['health_records'][0]['spo2'];
//         });
//         printqueue();
//       } else {
//         printqueue();
//       }
//     }
//   }

//   void printqueue() async {
//     ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Container(
//             width: MediaQuery.of(context).size.width,
//             child: Center(
//                 child: Text(
//               'ปริ้นผลตรวจ',
//               style: TextStyle(
//                   fontFamily: context.read<DataProvider>().fontFamily,
//                   fontSize: MediaQuery.of(context).size.width * 0.03),
//             )))));
//     List<int> bytes = [];

//     // Xprinter XP-N160I
//     final profile = await CapabilityProfile.load(name: 'XP-N160I');

//     // PaperSize.mm80 or PaperSize.mm58
//     final generator = Generator(PaperSize.mm58, profile);
//     // bytes += generator.setGlobalCodeTable('CP1252');
//     bytes += generator.text(context.read<DataProvider>().name_hospital,
//         styles: const PosStyles(align: PosAlign.center));

//     // bytes += generator.text('Queue',
//     //     styles: const PosStyles(
//     //         align: PosAlign.center,
//     //         width: PosTextSize.size2,
//     //         height: PosTextSize.size2,
//     //         fontType: PosFontType.fontA));
//     bytes += generator.text('');
//     bytes += generator.text("Q ${resTojson['queue_number']}",
//         styles: const PosStyles(
//             align: PosAlign.center,
//             width: PosTextSize.size3,
//             height: PosTextSize.size3,
//             fontType: PosFontType.fontA));
//     bytes += generator.text('\n');
//     bytes +=
//         generator.text('Doctor :   ${resTojson['todays'][0]['doctor_name']}');
//     bytes += generator.text(
//         'Care   :  ${resTojson['todays'][0]['care_name']} / ( ${resTojson['todays'][0]['slot']} )');
//     bytes += generator.text('\n');
//     bytes += generator.text('Health Information',
//         styles: const PosStyles(align: PosAlign.center));
//     bytes += generator.row([
//       PosColumn(
//           width: 2,
//           text: 'height',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'weight',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'temp',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'sys',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'dia',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: 'spo2',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//     ]);
//     bytes += generator.row([
//       PosColumn(
//           width: 2,
//           text: '${height}',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: '${weight}',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: '${temp}',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: '${bp_sys}',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: '${bp_dia}',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//       PosColumn(
//           width: 2,
//           text: '$spo2',
//           styles: const PosStyles(align: PosAlign.center, codeTable: 'CP1252')),
//     ]);
//     // bytes += generator.text(
//     //     '${resTojson['personal']['first_name']}   ${resTojson['personal']['last_name']}',
//     //     styles: const PosStyles(align: PosAlign.center, codeTable: '255'));
//     //  bytes += generator.text('$datatime');
//     printer?.printTest(bytes); //
//     printer?.printEscPos(bytes, generator);
//   }

//   @override
//   void initState() {
//     // TODO: implement initState
//     //  checkt_queue();
//     printer = ESMPrinter([
//       {'vendor_id': '1137', 'product_id': '85'}
//     ]);

//     setState(() {
//       dateTime = DateTime.now();
//       datatime = "${dateTime.hour}: " +
//           "${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}";
//     });
//     super.initState();
//   }

//   BoxDecoration boxDecorate = BoxDecoration(
//       color: Color(0xff31D6AA),
//       borderRadius: BorderRadius.circular(15),
//       boxShadow: [
//         BoxShadow(
//           color: Colors.grey,
//           offset: Offset(0, 4),
//           blurRadius: 5,
//         )
//       ]);

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     TextStyle style = TextStyle(
//         fontWeight: FontWeight.w500,
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: _width * 0.03,
//         color: Colors.white);
//     return ontap == false
//         ? GestureDetector(
//             onTap: Deviceprint, //checkt_queue,
//             child: Container(
//                 height: _height * 0.05,
//                 width: _width * 0.3,
//                 decoration: boxDecorate,
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.start,
//                     children: [
//                       Image.asset('assets/jhb.png'),
//                       Text('  ปริ้นคิว', style: style)
//                     ])))
//         : Container(
//             height: 0.06, width: 0.35, child: CircularProgressIndicator());
//   }
// }

class ButtonQueue extends StatefulWidget {
  const ButtonQueue({super.key});

  @override
  State<ButtonQueue> createState() => _ButtonQueueState();
}

class _ButtonQueueState extends State<ButtonQueue> {
  bool ontap = false;
  void addQueue() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Container(
            width: MediaQuery.of(context).size.width,
            child: Center(
                child: Text(
              'กำลังรับคิว',
              style: TextStyle(
                  fontFamily: context.read<DataProvider>().family,
                  fontSize: MediaQuery.of(context).size.width * 0.03),
            )))));
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/get_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
      'care_unit_id': context.read<DataProvider>().care_unit_id
    });

    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {
      if (resTojson['message'] == 'success') {
        setState(() {
          checkt_queue();
          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              ontap == false;
              Navigator.pop(context);
            });
          });
          Future.delayed(const Duration(seconds: 2), () {
            Get.offNamed('user_information');
          });
        });
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'รับคิวสำเร็จ',
                  style: TextStyle(
                      fontFamily: context.read<DataProvider>().family,
                      fontSize: MediaQuery.of(context).size.width * 0.03),
                )))));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'รับคิวไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  void checkt_queue() async {
    setState(() {
      ontap == true;
    });
    var url = Uri.parse('${context.read<DataProvider>().platfromURL}/check_q');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
      'care_unit_id': context.read<DataProvider>().care_unit_id
    });
    var resTojson = json.decode(res.body);
    if (res.statusCode == 200) {
      if (resTojson['health_records'].length != 0) {
        setState(() {
          addQueue();
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Container(
                width: MediaQuery.of(context).size.width,
                child: Center(
                    child: Text(
                  'ตรวจสุขภาพก่อนรับคิว',
                  style: TextStyle(
                      fontFamily: context.read<DataProvider>().family,
                      fontSize: MediaQuery.of(context).size.width * 0.03),
                )))));

        setState(() {
          Get.offNamed('healthrecord');
        });
      }
    } else {
      setState(() {
        ontap == false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'ไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  BoxDecoration boxDecorate = BoxDecoration(
      color: Color(0xff31D6AA),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 4),
          blurRadius: 5,
        )
      ]);
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.03,
        color: Colors.white);
    return ontap == false
        ? GestureDetector(
            onTap: checkt_queue,
            child: Container(
                height: _height * 0.05,
                width: _width * 0.3,
                decoration: boxDecorate,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image.asset('assets/jhb.png'),
                      Text('  รับคิว', style: style)
                    ])))
        : Container(
            height: 0.06, width: 0.35, child: CircularProgressIndicator());
  }
}

class ButtonAddAppointToday extends StatefulWidget {
  const ButtonAddAppointToday({super.key});

  @override
  State<ButtonAddAppointToday> createState() => _ButtonAddAppointTodayState();
}

class _ButtonAddAppointTodayState extends State<ButtonAddAppointToday> {
  bool ontap = false;
  void addAppointToday() async {
    var url = Uri.parse(
        '${context.read<DataProvider>().platfromURL}/add_appoint_today');
    var res = await http.post(url, body: {
      'public_id': context.read<DataProvider>().id,
      'care_unit_id': context.read<DataProvider>().care_unit_id
    });
    if (res.statusCode == 200) {
      setState(() {
        Future.delayed(const Duration(seconds: 2), () {
          Navigator.pop(context);
        });
        Future.delayed(const Duration(seconds: 2), () {
          Get.offNamed('user_information');
        });
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เพิ่มนัดหมายสำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));

      setState(() {
        ontap == false;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Container(
              width: MediaQuery.of(context).size.width,
              child: Center(
                  child: Text(
                'เพิ่มนัดหมายไม่สำเร็จ',
                style: TextStyle(
                    fontFamily: context.read<DataProvider>().family,
                    fontSize: MediaQuery.of(context).size.width * 0.03),
              )))));
    }
  }

  BoxDecoration boxDecorate = BoxDecoration(
      color: Color(0xff31D6AA),
      borderRadius: BorderRadius.circular(15),
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          offset: Offset(0, 4),
          blurRadius: 5,
        )
      ]);
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    TextStyle style = TextStyle(
        fontWeight: FontWeight.w500,
        fontFamily: context.read<DataProvider>().family,
        fontSize: _width * 0.03,
        color: Colors.white);
    return ontap == false
        ? GestureDetector(
            onTap: () {
              setState(() {
                ontap = true;
              });
              addAppointToday();
            },
            child: Container(
                height: _height * 0.05,
                width: _width * 0.3,
                decoration: boxDecorate,
                child: Row(children: [
                  Image.asset('assets/erbhjr.png'),
                  Text('เพิ่มนัดหมาย', style: style)
                ])))
        : Container(
            height: 0.06, width: 0.35, child: CircularProgressIndicator());
  }
}

class BorDer extends StatefulWidget {
  BorDer({super.key, this.child, this.height, this.width});
  var child;
  var height;
  var width;
  @override
  State<BorDer> createState() => _BorDerState();
}

class _BorDerState extends State<BorDer> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Container(
      child: Center(child: widget.child),
      height: widget.height == null ? _height * 0.025 : widget.height,
      width: widget.height == null ? _width * 0.35 : widget.height,
      decoration: BoxDecoration(border: Border.all()),
    );
  }
}

// class BoxStatusinform extends StatefulWidget {
//   BoxStatusinform({super.key, this.status});
//   var status;

//   @override
//   State<BoxStatusinform> createState() => _BoxStatusinformState();
// }

// class _BoxStatusinformState extends State<BoxStatusinform> {
//   String? status;
//   Timer? _timer;
//   var resTojson;
//   var resTojson2;

//   Future<void> check_status() async {
//     var url = Uri.parse(
//         '${context.read<DataProvider>().platfromURL}/get_video_status');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });

//     resTojson = json.decode(res.body);
//     if (resTojson['message'] == 'finished' ||
//         resTojson['message'] == 'completed') {
//       setState(() {
//         print('completedเเล้ว');
//         status = resTojson['message'];
//         stop();
//         get_Examination();
//       });
//     }
//   }

//   void get_Examination() async {
//     var url = Uri.parse(
//         'https://emr-life.com/clinic_master/clinic/Api/get_doctor_exam');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     resTojson2 = json.decode(res.body);

//     print('--------------------$resTojson2');
//     setState(() {});
//   }

//   void lop() {
//     _timer = Timer.periodic(Duration(seconds: 2), (timer) {
//       setState(() {
//         check_status();
//         print('รอผลตรวจ');
//       });
//     });
//   }

//   void stop() {
//     setState(() {
//       _timer?.cancel();
//     });
//   }

//   @override
//   void initState() {
//     printer = ESMPrinter([
//       {'vendor_id': '1137', 'product_id': '85'}
//     ]);
//     get_Examination();
//     status = widget.status;
//     if (status == 'end') {
//       lop();
//     }
//     // TODO: implement initState
//     super.initState();
//   }

//   String datatime = "";
//   ESMPrinter? printer;

//   String doctor_note = '--';
//   String dx = '--';
//   BluetoothPrinter? selectedPrinter;
//   bool finished_check_status = false;
//   var devices = <BluetoothPrinter>[];
//   List default_deivces = [];
//   Future<void> get_finished() async {
//     var url =
//         Uri.parse('${context.read<DataProvider>().platfromURL}/finish_appoint');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       finished_check_status = false;
//       showDialog(
//           context: context,
//           builder: (BuildContext context) {
//             return Popup(
//                 fontSize: 0.05,
//                 texthead: 'สำเร็จ',
//                 pathicon: 'assets/correct.png');
//           });

//       Timer(Duration(seconds: 2), () {
//         Get.offNamed('home');
//       });
//     });
//   }

//   Future<void> get_exam() async {
//     var url = Uri.parse(
//         '${context.read<DataProvider>().platfromURL}/get_doctor_exam');
//     var res = await http.post(url, body: {
//       'public_id': context.read<DataProvider>().id,
//     });
//     setState(() {
//       resTojson2 = json.decode(res.body);
//       doctor_note = resTojson2['data']['doctor_note'];
//       dx = resTojson2['data']['dx'];
//       if (resTojson2 != null) {
//         get_finished();
//       }
//     });
//   }

//   void printexam() async {
//     List<int> bytes = [];
//     final profile = await CapabilityProfile.load(name: 'XP-N160I');
//     final generator = Generator(PaperSize.mm58, profile);
//     bytes += generator.text(context.read<DataProvider>().name_hospital,
//         styles: const PosStyles(align: PosAlign.center));

//     bytes += generator.text('Examination',
//         styles: const PosStyles(
//             width: PosTextSize.size1, height: PosTextSize.size1));
//     bytes += generator.text('\n');
//     bytes += generator.text('Doctor  :  pairot tanyajasesn');
//     bytes += generator.text('Results :  ${dx}');
//     bytes += generator.text('        :  ${doctor_note}');
//     // printer?.printTest(bytes);

//     printer?.printEscPos(bytes, generator);
//   }

//   void finished() async {
//     print('finished');

//     get_exam();
//     setState(() {
//       var dateTime = DateTime.now();
//       datatime = "${dateTime.hour}: " +
//           "${dateTime.minute}  ${dateTime.day}/${dateTime.month}/${dateTime.year}";
//     });
//     super.initState();
//   }

//   @override
//   Widget build(BuildContext context) {
//     double _width = MediaQuery.of(context).size.width;
//     double _height = MediaQuery.of(context).size.height;
//     TextStyle style = TextStyle(
//         color: Color(0xff76FFD5),
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: _width * 0.04);
//     TextStyle style2 = TextStyle(
//         color: Color(0xff1B6286),
//         fontFamily: context.read<DataProvider>().fontFamily,
//         fontSize: _width * 0.04);
//     return widget.status != null
//         ? Container(
//             child: status == 'processing'
//                 ? Container(
//                     child: Column(
//                       children: [
//                         Text('ถึงคิวเเล้ว', style: style),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                     builder: (context) => PrePareVideo()));
//                           },
//                           child: BoxWidetdew(
//                             radius: 2.0,
//                             color: Colors.blue,
//                             width: 0.3,
//                             height: 0.05,
//                             text: 'Video',
//                             textcolor: Colors.white,
//                             fontWeight: FontWeight.w500,
//                             fontSize: 0.04,
//                           ),
//                         )
//                       ],
//                     ),
//                   )
//                 : status == 'end'
//                     ? Container(
//                         child: Center(
//                           child: Container(
//                               height: _height * 0.15,
//                               width: _width * 0.7,
//                               decoration: BoxDecoration(
//                                   borderRadius: BorderRadius.circular(10),
//                                   border: Border.all(
//                                       color: Color(0xff76FFD5), width: 8)),
//                               child: Column(
//                                 mainAxisAlignment: MainAxisAlignment.center,
//                                 children: [
//                                   Text('การตรวจเสร็จสิ้นกรุณารอผลตรวจ',
//                                       style: style),
//                                   Container(
//                                     width: MediaQuery.of(context).size.width *
//                                         0.07,
//                                     height: MediaQuery.of(context).size.width *
//                                         0.07,
//                                     child: CircularProgressIndicator(
//                                         color: Color(0xff76FFD5)),
//                                   )
//                                 ],
//                               )),
//                         ),
//                       )
//                     : status == 'completed'
//                         ? Container(
//                             height: _height * 0.3,
//                             // color: Colors.red,
//                             child: ListView(
//                               children: [
//                                 Container(
//                                   child: Column(
//                                     children: [
//                                       Text('รับผลตรวจ', style: style),
//                                       resTojson2 != null
//                                           ? resTojson2['data'] != null
//                                               ? Container(
//                                                   width: _width * 0.7,
//                                                   decoration: BoxDecoration(
//                                                       borderRadius:
//                                                           BorderRadius.circular(
//                                                               10),
//                                                       border: Border.all(
//                                                           color:
//                                                               Color(0xff76FFD5),
//                                                           width: 8)),
//                                                   child: Padding(
//                                                     padding:
//                                                         const EdgeInsets.all(
//                                                             8.0),
//                                                     child: Column(
//                                                       children: [
//                                                         Text(
//                                                           context
//                                                               .read<
//                                                                   DataProvider>()
//                                                               .name_hospital,
//                                                           style: style2,
//                                                         ),
//                                                         Row(
//                                                           children: [
//                                                             Text('Examination',
//                                                                 style: style2),
//                                                           ],
//                                                         ),
//                                                         SizedBox(
//                                                             height:
//                                                                 _height * 0.01),
//                                                         Container(
//                                                           child: Row(
//                                                             crossAxisAlignment:
//                                                                 CrossAxisAlignment
//                                                                     .start,
//                                                             children: [
//                                                               Container(
//                                                                 child: Column(
//                                                                   mainAxisAlignment:
//                                                                       MainAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         'Doctor',
//                                                                         style:
//                                                                             style2),
//                                                                     Text(
//                                                                         'Results',
//                                                                         style:
//                                                                             style2)
//                                                                   ],
//                                                                 ),
//                                                               ),
//                                                               SizedBox(
//                                                                 width: _width *
//                                                                     0.02,
//                                                               ),
//                                                               Container(
//                                                                 child: Column(
//                                                                   crossAxisAlignment:
//                                                                       CrossAxisAlignment
//                                                                           .start,
//                                                                   children: [
//                                                                     Text(
//                                                                         ": ${context.read<DataProvider>().dataidcard['todays'][0]['doctor_name']}",
//                                                                         style:
//                                                                             style2),
//                                                                     Container(
//                                                                       width:
//                                                                           _width *
//                                                                               0.5,
//                                                                       child: Text(
//                                                                           ": ${resTojson2['data']['doctor_note']}",
//                                                                           style:
//                                                                               style2),
//                                                                     ),
//                                                                     Container(
//                                                                       width:
//                                                                           _width *
//                                                                               0.5,
//                                                                       child: Text(
//                                                                           ": ${resTojson2['data']['dx']}",
//                                                                           style:
//                                                                               style2),
//                                                                     )
//                                                                   ],
//                                                                 ),
//                                                               )
//                                                             ],
//                                                           ),
//                                                         )
//                                                       ],
//                                                     ),
//                                                   ),
//                                                 )
//                                               : Container()
//                                           : Container(
//                                               width: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.05,
//                                               height: MediaQuery.of(context)
//                                                       .size
//                                                       .width *
//                                                   0.05,
//                                               child: CircularProgressIndicator(
//                                                   color: Color(0xff76FFD5)),
//                                             ),
//                                     ],
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : status == 'finished'
//                             ? Container(
//                                 height: _height * 0.3,
//                                 child: ListView(
//                                   children: [
//                                     Container(
//                                       child: Column(
//                                         children: [
//                                           Text('รับผลตรวจ', style: style),
//                                           resTojson2 != null
//                                               ? resTojson2['data'] != null
//                                                   ? Container(
//                                                       width: _width * 0.7,
//                                                       decoration: BoxDecoration(
//                                                           borderRadius:
//                                                               BorderRadius
//                                                                   .circular(10),
//                                                           border: Border.all(
//                                                               color: Color(
//                                                                   0xff76FFD5),
//                                                               width: 8)),
//                                                       child: Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .all(8.0),
//                                                         child: Column(
//                                                           children: [
//                                                             Text(
//                                                               context
//                                                                   .read<
//                                                                       DataProvider>()
//                                                                   .name_hospital,
//                                                               style: style2,
//                                                             ),
//                                                             Row(
//                                                               children: [
//                                                                 Text(
//                                                                     'Examination',
//                                                                     style:
//                                                                         style2),
//                                                               ],
//                                                             ),
//                                                             SizedBox(
//                                                                 height:
//                                                                     _height *
//                                                                         0.01),
//                                                             Container(
//                                                               child: Row(
//                                                                 crossAxisAlignment:
//                                                                     CrossAxisAlignment
//                                                                         .start,
//                                                                 children: [
//                                                                   Container(
//                                                                     child:
//                                                                         Column(
//                                                                       mainAxisAlignment:
//                                                                           MainAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                             'Doctor',
//                                                                             style:
//                                                                                 style2),
//                                                                         Text(
//                                                                             'Results',
//                                                                             style:
//                                                                                 style2)
//                                                                       ],
//                                                                     ),
//                                                                   ),
//                                                                   SizedBox(
//                                                                     width:
//                                                                         _width *
//                                                                             0.02,
//                                                                   ),
//                                                                   Container(
//                                                                     child:
//                                                                         Column(
//                                                                       crossAxisAlignment:
//                                                                           CrossAxisAlignment
//                                                                               .start,
//                                                                       children: [
//                                                                         Text(
//                                                                             ": ${context.read<DataProvider>().dataidcard['todays'][0]['doctor_name']}",
//                                                                             style:
//                                                                                 style2),
//                                                                         Container(
//                                                                           width:
//                                                                               _width * 0.5,
//                                                                           child: Text(
//                                                                               ": ${resTojson2['data']['doctor_note']}",
//                                                                               style: style2),
//                                                                         ),
//                                                                         Container(
//                                                                           width:
//                                                                               _width * 0.5,
//                                                                           child: Text(
//                                                                               ": ${resTojson2['data']['dx']}",
//                                                                               style: style2),
//                                                                         )
//                                                                       ],
//                                                                     ),
//                                                                   )
//                                                                 ],
//                                                               ),
//                                                             )
//                                                           ],
//                                                         ),
//                                                       ),
//                                                     )
//                                                   : Container()
//                                               : Container(
//                                                   width: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.05,
//                                                   height: MediaQuery.of(context)
//                                                           .size
//                                                           .width *
//                                                       0.05,
//                                                   child:
//                                                       CircularProgressIndicator(
//                                                           color: Color(
//                                                               0xff76FFD5)),
//                                                 ),
//                                         ],
//                                       ),
//                                     ),
//                                   ],
//                                 ),
//                               )
//                             : Text('--', style: style))
//         : Container();
//   }
// }
