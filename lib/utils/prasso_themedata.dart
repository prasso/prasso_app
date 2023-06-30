import 'package:flutter/material.dart';

final ThemeData prassoThemeData = ThemeData(
    scaffoldBackgroundColor: PrassoColors.lightGray[500],
    colorScheme: ColorScheme(
        background: PrassoColors.lightGray[500]!,
        primary: PrassoColors.black,
        secondary: PrassoColors.brightOrange,
        surface: PrassoColors.lightGray[500]!,
        error: PrassoColors.brightOrange,
        onPrimary: PrassoColors.lightGray[500]!,
        onSecondary: PrassoColors.lightGray[500]!,
        onSurface: PrassoColors.lightGray[500]!,
        onError: PrassoColors.lightGray[500]!,
        onBackground: PrassoColors.lightGray[500]!,
        brightness: Brightness.light),
    appBarTheme: AppBarTheme(
      foregroundColor: PrassoColors.lightGray[500],
      color: PrassoColors.primary[500],
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    primaryColorDark: PrassoColors.black,
    primaryColor: PrassoColors.black,
    brightness: Brightness.light,
    secondaryHeaderColor: PrassoColors.brightOrange,
    primaryColorLight: PrassoColors.lightGray[500]);

class PrassoColors {
  PrassoColors._(); // this basically makes it so you can instantiate this class

  static const _blackPrimaryValue = 0xFF181818;
  static const _mainPrimaryValue = 0xFF181818;
  static const _olivePrimaryValue = 0xFF228B22;
  static const _brightOrangePrimaryValue = 0xFFFF0000;
  static const _lightGreenPrimaryValue = 0xFF96f97b;
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
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
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
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
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
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
    },
  );

  static const MaterialColor brightOrange = MaterialColor(
    _brightOrangePrimaryValue,
    <int, Color>{
      50: Color(0xFFe0e0e0),
      100: Color(0xFFb3b3b3),
      200: Color(0xFF808080),
      300: Color(0xFF4d4d4d),
      400: Color(0xFF262626),
      500: Color(_brightOrangePrimaryValue),
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
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
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
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
      600: Color(0xFF181818),
      700: Color(0xFF181818),
      800: Color(0xFF181818),
      900: Color(0xFF181818),
    },
  );
}
