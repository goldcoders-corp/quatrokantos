// ignore_for_file: prefer_int_literals

import 'package:flutter/material.dart';

class RoundedInputField extends StatelessWidget {
  const RoundedInputField({
    required this.hintText,
    required this.labelText,
    required this.helperText,
    this.onChanged,
    this.color,
    this.icon,
    this.prefixText,
    this.suffixText,
    this.textStyle = const TextStyle(color: Color(0xFFFF4081)),
    this.helperStyle = const TextStyle(color: Color(0xFFFF4081)),
    this.hintStyle = const TextStyle(color: Colors.white30),
    this.labelStyle = const TextStyle(color: Color(0xffb69859)),
    this.border = const OutlineInputBorder(
      gapPadding: 1.0,
      borderRadius: BorderRadius.all(Radius.circular(25.0)),
      borderSide: BorderSide(color: Color(0xffb69859)),
    ),
    this.focusColor,
    super.key,
  });
  final String hintText;
  final String helperText;
  final String labelText;
  final ValueChanged<String>? onChanged;
  final Color? color;
  final Color? focusColor;
  final Icon? icon;
  final String? prefixText;
  final String? suffixText;
  final TextStyle? textStyle;
  final TextStyle? helperStyle;
  final TextStyle? labelStyle;
  final TextStyle? hintStyle;
  final OutlineInputBorder? border;

  Icon fieldIcon(IconData icon, {Color color = Colors.white}) {
    return Icon(icon, color: color);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      style: const TextStyle(fontSize: 18),
      decoration: InputDecoration(
        focusedBorder: border,
        focusColor: focusColor,
        enabledBorder: border,
        hintText: hintText,
        helperText: helperText,
        helperStyle: helperStyle,
        labelText: labelText,
        labelStyle: labelStyle,
        prefixIcon: icon,
        hintStyle: hintStyle,
        prefixText: prefixText,
        suffixText: suffixText,
        suffixStyle: textStyle,
      ),
    );
  }
}
