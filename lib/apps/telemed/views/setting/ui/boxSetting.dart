// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

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
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    TextStyle style1 = TextStyle(
        color: const Color.fromARGB(255, 20, 142, 130),
        fontSize: width * 0.04,
        fontWeight: FontWeight.w600);
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
      child: Container(
        width: width * 0.98,
        height: height * 0.06,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: const Color.fromARGB(255, 255, 255, 255),
            boxShadow: const [
              BoxShadow(
                blurRadius: 5.0,
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
                  child: SizedBox(
                    width: width * 0.98,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                            width: width * 0.47,
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  widget.text == null
                                      ? const Center(child: Text(''))
                                      : Center(
                                          child: Text(
                                            widget.text.toString(),
                                            style: widget.textstyle ?? style1,
                                          ),
                                        ),
                                ],
                              ),
                            )),
                        SizedBox(
                            width: width * 0.45,
                            child: const Row(
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
