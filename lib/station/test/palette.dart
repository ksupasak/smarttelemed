//palette.dart
import 'package:flutter/material.dart';

class Palette {
  static const MaterialColor kToDark = const MaterialColor(
    0xff085b9e, // 0% comes in here, this will be color picked if no shade is selected when defining a Color property which doesn’t require a swatch.
    const <int, Color>{
      50: const Color(0xff07528e), //10%
      100: const Color(0xff06497e), //20%
      200: const Color(0xff06406f), //30%
      300: const Color(0xff05375f), //40%
      400: const Color(0xff042e4f), //50%
      500: const Color(0xff03243f), //60%
      600: const Color(0xff021b2f), //70%
      700: const Color(0xff021220), //80%
      800: const Color(0xff010910), //90%
      900: const Color(0xff000000), //100%
    },
  );
}
