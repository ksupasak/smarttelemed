import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BackGroundSmart_Health extends StatefulWidget {
  BackGroundSmart_Health({
    super.key,
    this.BackGroundWidth,
    this.BackGroundHeight,
    required this.BackGroundColor,
  });
  double? BackGroundWidth;
  double? BackGroundHeight;
  List<Color> BackGroundColor;
  @override
  State<BackGroundSmart_Health> createState() => _BackGroundSmart_HealthState();
}

class _BackGroundSmart_HealthState extends State<BackGroundSmart_Health> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.BackGroundWidth == null
          ? MediaQuery.of(context).size.width
          : widget.BackGroundHeight,
      height: widget.BackGroundHeight == null
          ? MediaQuery.of(context).size.height
          : widget.BackGroundHeight,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: widget.BackGroundColor)),
    );
  }
}
