import 'package:flutter/material.dart' show Brightness, ThemeData;
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';

class AppTheme {
  final ThemeData lightTheme = ThemeData.light().copyWith(
      brightness: Brightness.light,
      primaryColor: appColors[PRIMARY],
      accentColor: appColors[ACCENT],
      backgroundColor: appColors[BG],
      buttonColor: appColors[PRIMARY]);

  final ThemeData darkTheme = ThemeData.dark().copyWith(
      brightness: Brightness.dark,
      primaryColor: appColors[PRIMARY_DARK],
      backgroundColor: appColors[BG_DARK],
      accentColor: appColors[ACCENT_DARK],
      buttonColor: appColors[SECONDARY_DARK]);
}
