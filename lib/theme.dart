import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomTheme {
  const CustomTheme();

  static const Color black = Colors.black;
  static const Color white = Colors.white;
  static const Color transparent = Colors.transparent;
  static const Color whiteAppBarBackground = Colors.white70;
  static const Color greyBackground = Color(0x3DFFFFFF);
  static const Color whiteBackground = Color(0xFFD3D3D3);
  static const Color green = Color(0xFF008000);
  static const Color paleGreen = Color(0xFFc1f9a2);
  static const Color red = Color(0xFFFF0000);
  static const Color paleRed = Color(0xFFff7f7f);
  static const Color paleYellow = Color(0xFFFFFF99);
  static const Color bronze = Color(0xFFb08d57);
  static const Color silver = Color(0xFFC0C0C0);
  static const Color gold = Color(0xFFFFD700);
  static const Color loginGradientEnd = Color(0xFF0096c7);
  static const Color loginGradientStart = Color(0xFFd9ed92);


  static const LinearGradient primaryGradient = LinearGradient(
    colors: <Color>[loginGradientStart, loginGradientEnd],
    stops: <double>[0.0, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
