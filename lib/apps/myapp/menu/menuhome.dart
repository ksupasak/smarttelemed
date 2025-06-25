import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/apps/myapp/menu/callcenter.dart';
import 'package:smarttelemed/apps/myapp/menu/data_hospital.dart';
import 'package:smarttelemed/apps/myapp/menu/internet.dart';
import 'package:smarttelemed/apps/myapp/menu/map.dart';
import 'package:smarttelemed/apps/myapp/menu/treatment_rights.dart';
import 'package:smarttelemed/apps/myapp/provider/provider.dart';
import 'package:smarttelemed/apps/station/views/pages/home.dart';

class MenuHome extends StatefulWidget {
  const MenuHome({super.key});

  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  List items = [
    'assets/image_menu/filling-medical-record.jpg',
    'assets/image_menu/networking-concept.jpg',
    'assets/image_menu/medical-checkup.jpg',
    'assets/image_menu/h-map.jpg',
    'assets/image_menu/stethoscope-documents.jpg',
    'assets/image_menu/call-center-office.jpg',
  ];
  List textitems = [];

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: _width,
          height: _height,
          child: Stack(
            children: [
              Positioned(
                child: SvgPicture.asset(
                  'assets/backgrund/backgrund-home.svg',
                  fit: BoxFit.fill,
                ),
              ),
              Positioned(
                child: ListView(
                  children: [
                    Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: _width * 0.1,
                            height: _width * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(100),
                            ),
                            child: Image.asset(
                              'assets/Ellipse 1.png',
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                        Text(
                          context.read<DataProvider>().name_hospital,
                          style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: _width * 0.06,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff31D6AA),
                            shadows: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Services',
                          style: TextStyle(
                            fontFamily: context.read<DataProvider>().family,
                            fontSize: _width * 0.06,
                            fontWeight: FontWeight.w500,
                            color: Color(0xff1B6286),
                            shadows: [
                              BoxShadow(
                                blurRadius: 1,
                                color: Colors.black,
                                offset: Offset(1, 2),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.02),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            // Navigator.pop(context);
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Homeapp(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/filling-medical-record.jpg',
                            'ตรวจสุขภาพ',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Internet(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/networking-concept.jpg',
                            'บริการ Internet',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Data_Hospital(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/medical-checkup.jpg',
                            'ข้อมูลโรงพยาบาล',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.01),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Image_Map(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/h-map.jpg',
                            'แผนที่',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => Treatment_Rights(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/stethoscope-documents.jpg',
                            'ตรวจสอบสิทธิ์',
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CallCenter(),
                              ),
                            );
                          },
                          child: boxmenu(
                            'assets/image_menu/call-center-office.jpg',
                            'สอบถามข้อมูล',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: _height * 0.1),
                    Container(
                      //   color: Colors.white,
                      child: CarouselSlider.builder(
                        itemCount: items.length,
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          autoPlay: true,
                        ),
                        itemBuilder:
                            (BuildContext context, int index, int realIndex) {
                              String item = items[index];
                              return Padding(
                                padding: const EdgeInsets.all(5.0),
                                child: Container(
                                  child: Center(
                                    child: Container(
                                      height: _height * 0.25,
                                      width: _width,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        boxShadow: [
                                          BoxShadow(
                                            blurRadius: 10,
                                            color: Colors.black,
                                            offset: Offset(2, 2),
                                          ),
                                        ],
                                      ),
                                      //color: Colors.amber,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(5),
                                        child: Image.asset(
                                          item,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                      ),
                    ),
                    SizedBox(height: _height * 0.01),
                    SizedBox(height: _height * 0.08),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget boxmenu(String image, String text) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;

    return Container(
      width: _width * 0.3,
      height: _width * 0.3,
      decoration: BoxDecoration(
        border: Border.all(color: Color.fromARGB(100, 255, 255, 255)),
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black, blurRadius: 2, offset: Offset(0, 2)),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            child: Container(
              width: _width * 0.3,
              height: _width * 0.3,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15),
                child: image != ''
                    ? Image.asset(image, fit: BoxFit.fill)
                    : Container(),
              ),
            ),
          ),
          Positioned(
            child: Container(
              width: _width * 0.3,
              height: _width * 0.3,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                color: Color.fromARGB(100, 0, 0, 0),
              ),
              child: Center(
                child: text != ''
                    ? Text(
                        text,
                        style: TextStyle(
                          fontSize: _width * 0.04,
                          color: Colors.white,
                          fontFamily: context.read<DataProvider>().family,
                        ),
                      )
                    : SizedBox(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
