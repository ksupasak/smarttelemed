import 'package:flutter/material.dart';

ButtonStyle stylebutter(Color color) {
  return ElevatedButton.styleFrom(
    backgroundColor: color,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(5),
    ),
  );
}
