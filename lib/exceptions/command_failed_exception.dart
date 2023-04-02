// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';
import 'package:quatrokantos/helpers/writter_helper.dart';

class CommandFailedException implements Exception {
  static Future<void> log(String e, String stacktrace) async {
    if (dotenv.env['DEBUG']! == 'TRUE' && kReleaseMode || !kReleaseMode) {
      Get.snackbar(
        e,
        stacktrace,
        duration: const Duration(milliseconds: 30000),
        icon: const Icon(Icons.warning, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
        isDismissible: true,
        dismissDirection: DismissDirection.horizontal,
      );
    } else {
      var folder = dotenv.env['APP_NAME']!.toLowerCase();
      // ignore: unnecessary_string_escapes
      final text = ReplaceHelper(text: folder, regex: r'\s+');
      folder = text.replace();
      const filename = 'error_logs.txt';
      final filePath =
          p.join(PC.userDirectory, '.local', 'share', '.$folder', filename);
      await WritterHelper.log(
        filePath: filePath,
        // ignore: noop_primitive_operations
        e: e.toString(),
        stacktrace: stacktrace,
      );
    }
  }
}
