import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart'; 

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
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return AlertDialog(
      icon: widget.pathicon == null
          ? null
          : Container(
              width: _width * 0.8,
              child: Center(
                child: Image.asset(
                  "${widget.pathicon}",
                  width: _width * 0.5,
                  height: _height * 0.2,
                ),
              ),
            ),
      title: widget.texthead == null
          ? null
          : Text(
              "${widget.texthead}",
              style: TextStyle(
                  fontFamily:
                      'Prompt', //context.read<DataProvider>().fontFamily,
                  fontSize:
                      widget.fontSize == null ? 16 : _width * widget.fontSize),
            ),
      content: widget.textbody == null
          ? null
          : Text(
              "${widget.textbody}",
              style: TextStyle(
                  fontFamily:
                      'Prompt', //context.read<DataProvider>().fontFamily,
                  fontSize:
                      widget.fontSize == null ? 16 : _width * widget.fontSize),
            ),
      actions: widget.buttonbar == null ? null : widget.buttonbar,
    );
  }
}
