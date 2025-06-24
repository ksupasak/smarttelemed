// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

class Popup extends StatefulWidget {
  Popup({
    super.key,
    this.texthead,
    this.textbody,
    this.pathicon,
    this.buttonbar,
    this.fontSize,
  });
  var texthead;
  var textbody;
  var pathicon;
  var buttonbar;
  var fontSize;
  @override
  State<Popup> createState() => _PopupState();
}

class _PopupState extends State<Popup> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return AlertDialog(
      icon: widget.pathicon == null
          ? null
          : SizedBox(
              width: width * 0.8,
              child: Center(
                child: Image.asset(
                  "${widget.pathicon}",
                  width: width * 0.5,
                  height: height * 0.2,
                ),
              ),
            ),
      title: widget.texthead == null
          ? null
          : Text(
              "${widget.texthead}",
              style: TextStyle(
                  fontSize:
                      widget.fontSize == null ? 16 : width * widget.fontSize),
            ),
      content: widget.textbody == null
          ? null
          : Text(
              "${widget.textbody}",
              style: TextStyle(
                  fontSize:
                      widget.fontSize == null ? 16 : width * widget.fontSize),
            ),
      actions: widget.buttonbar,
    );
  }
}
