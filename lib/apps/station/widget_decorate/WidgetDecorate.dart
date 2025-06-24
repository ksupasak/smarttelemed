import 'package:flutter/material.dart';

TextStyle style_text(
    {double sized = 18,
    TextAlign textAlign = TextAlign.end,
    Color colors = const Color.fromARGB(255, 0, 0, 0),
    FontWeight fontWeight = FontWeight.w500,
    List<Shadow>? shadow}) {
  TextStyle style = TextStyle(
      fontSize: sized,
      color: colors,
      fontWeight: fontWeight,
      shadows: shadow,
      fontFamily: 'Prompt');
  return style;
}
