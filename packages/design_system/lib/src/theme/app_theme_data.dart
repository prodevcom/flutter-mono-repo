import 'package:flutter/material.dart';

abstract class AppThemeData {
  Color get primaryColor;
  Color get secondaryColor;
  Color get backgroundColor;
  Color get surfaceColor;
  Color get errorColor;
  String get fontFamily;

  ThemeData buildTheme();
}
