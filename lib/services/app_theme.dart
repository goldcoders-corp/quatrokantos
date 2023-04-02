import 'package:flutter/material.dart' show Brightness, ColorScheme, ThemeData;
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';

class AppTheme {
  final ThemeData lightTheme = ThemeData.light().copyWith(
    brightness: Brightness.light,
    primaryColor: appColors[PRIMARY],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: appColors[ACCENT],
      background: appColors[BG],
    ),
  );

  final ThemeData darkTheme = ThemeData.dark().copyWith(
    brightness: Brightness.dark,
    primaryColor: appColors[PRIMARY_DARK],
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: appColors[ACCENT_DARK],
      background: appColors[BG_DARK],
    ),
  );
}
