import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/constants/default_size.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    super.key,
    this.text,
    this.onPress,
    this.textColor = Colors.white,
    this.bgColor = const Color(0xffc541da),
  });
  final String? text;
  final void Function()? onPress;
  final Color textColor;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: bgColor,
      child: MaterialButton(
        minWidth: Get.width,
        padding: const EdgeInsets.all(defaultPadding),
        onPressed: onPress,
        child: Text(
          text!,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
