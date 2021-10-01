import 'package:flutter/material.dart';

final ThemeData prassoThemeData = ThemeData(
    scaffoldBackgroundColor: PrassoColors.lightGray[500],
    backgroundColor: PrassoColors.lightGray[500],
    appBarTheme: AppBarTheme(
      foregroundColor: PrassoColors.lightGray[500],
      color: PrassoColors.primary[500],
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    primaryColorDark: PrassoColors.olive,
    primaryColor: PrassoColors.brightGreen,
    brightness: Brightness.light,
    primaryColorBrightness: Brightness.light,
    accentColor: PrassoColors.brightBlue,
    accentColorBrightness: Brightness.light,
    primaryColorLight: PrassoColors.lightGray[500]);

class PrassoColors {
  PrassoColors._(); // this basically makes it so you can instantiate this class

  static const _blackPrimaryValue = 0xFF000000;
  static const _mainPrimaryValue = 0xFF494859;
  static const _olivePrimaryValue = 0xFF648025;
  static const _brightBluePrimaryValue = 0xFF54CDDF;
  static const _lightGreenPrimaryValue = 0xFF9CC378;
  static const _lightGrayPrimaryValue = 0xFFF2F2F2;

  static const MaterialColor black = MaterialColor(
    _blackPrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_blackPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor primary = MaterialColor(
    _mainPrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_mainPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor olive = MaterialColor(
    _olivePrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_olivePrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor brightBlue = MaterialColor(
    _brightBluePrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_brightBluePrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor brightGreen = MaterialColor(
    _lightGreenPrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_lightGreenPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );

  static const MaterialColor lightGray = MaterialColor(
    _lightGrayPrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_lightGrayPrimaryValue),
      600: Color(0xFF000000),
      700: Color(0xFF000000),
      800: Color(0xFF000000),
      900: Color(0xFF000000),
    },
  );
}
