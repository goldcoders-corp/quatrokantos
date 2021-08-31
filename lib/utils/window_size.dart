import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:window_size/window_size.dart';

void minWindowSize() {
  if (GetPlatform.isWindows == true ||
      GetPlatform.isLinux == true ||
      GetPlatform.isMacOS == true) {
    setWindowTitle(dotenv.env['APP_NAME']!);
    setWindowMinSize(const Size(800, 500));
    setWindowMaxSize(Size.infinite);
  }
}
