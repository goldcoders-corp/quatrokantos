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
      String folder = dotenv.env['APP_NAME']!.toLowerCase();
      // ignore: unnecessary_string_escapes
      final ReplaceHelper text = ReplaceHelper(text: folder, regex: '\\s+');
      folder = text.replace();
      const String filename = 'error_logs.txt';
      final String filePath =
          p.join(PC.userDirectory, '.local', 'share', '.$folder', filename);
      await WritterHelper.log(
          filePath: filePath, e: e.toString(), stacktrace: stacktrace);
    }
  }
}
