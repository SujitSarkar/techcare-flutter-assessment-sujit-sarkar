import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primaryColor = Color(0xff10A6ED);
  static const Color successColor = Colors.green;
  static const Color errorColor = Color(0xffFF0000);
  static const Color warningColor = Color(0xffD35500);
  static const Color lightCardColor = Colors.white;

  // Bottom Navigation Bar Colors
  static const Color bottomNavBarLightBg = Colors.white;
  static const Color bottomNavBarDarkBg = Color(0xff121212);

  // Primary swatch
  static const int primarySwatch = 0xff10A6ED;

  static const Map<int, Color> primaryColorMap = {
    50: Color.fromRGBO(16, 166, 237, .1),
    100: Color.fromRGBO(16, 166, 237, .2),
    200: Color.fromRGBO(16, 166, 237, .3),
    300: Color.fromRGBO(16, 166, 237, .4),
    400: Color.fromRGBO(16, 166, 237, .5),
    500: Color.fromRGBO(16, 166, 237, .6),
    600: Color.fromRGBO(16, 166, 237, .7),
    700: Color.fromRGBO(16, 166, 237, .8),
    800: Color.fromRGBO(16, 166, 237, .9),
    900: Color.fromRGBO(16, 166, 237, 1),
  };
}
