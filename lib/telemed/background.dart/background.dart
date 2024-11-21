import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:smarttelemed/telemed/background.dart/boxTime.dart';
import 'package:smarttelemed/telemed/provider/provider.dart';

class Background extends StatefulWidget {
  const Background({super.key});

  @override
  State<Background> createState() => _BackgroundState();
}

class _BackgroundState extends State<Background> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    DataProvider provider = context.watch<DataProvider>();
    TextStyle textStyle =
        TextStyle(color: Colors.white, fontSize: width * 0.045);
    return Positioned(
        child: Container(
      width: width,
      height: height,
      color: Colors.white,
      child: Column(
        children: [
          Stack(
            children: [
              Positioned(
                child: SizedBox(
                  height: height * 0.2,
                  width: width,
                  child: SvgPicture.asset(
                    'assets/Frame 9178.svg',
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(
                width: width,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(provider.name_hospital, style: textStyle),
                          Text(provider.care_unit, style: textStyle),
                        ],
                      ),
                      const BoxTime(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}
