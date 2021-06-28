import 'package:flutter/material.dart';

ThemeData buildTheme({bool dark = false}) {
  TextTheme _buildTextTheme(TextTheme base) {
    return base.copyWith();
  }

  final ThemeData base = dark ? ThemeData.dark() : ThemeData.light();

  return base.copyWith(
    textTheme: _buildTextTheme(base.textTheme),
    primaryColor: Color(0xff9D69A3),
    accentColor: Color(0xff61707D),
    visualDensity: VisualDensity.adaptivePlatformDensity,
    floatingActionButtonTheme: base.floatingActionButtonTheme.copyWith(
      backgroundColor: Color(0xfffccd0b),
      foregroundColor: Colors.white,
    ),
  );
}
