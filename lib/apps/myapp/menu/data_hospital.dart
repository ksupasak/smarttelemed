import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

class Data_Hospital extends StatefulWidget {
  const Data_Hospital({super.key});

  @override
  State<Data_Hospital> createState() => _Data_HospitalState();
}

class _Data_HospitalState extends State<Data_Hospital> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
        child: Stack(children: [
          Positioned(
              child: Container(
            width: _width,
            height: _height,
            child: Image.asset(
              'assets/image_menu/information.png',
              fit: BoxFit.fill,
            ),
          )),
          Positioned(
              child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onDoubleTap: () {
                Navigator.pop(context);
              },
              child: Container(
                width: 80,
                height: 80,
                child: Center(
                  child: Icon(
                    Icons.arrow_back,
                    color: Colors.grey,
                    size: 40,
                  ),
                ),
              ),
            ),
          ))
        ]),
      ),
    );
  }
}
