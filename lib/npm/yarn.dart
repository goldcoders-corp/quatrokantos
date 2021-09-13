import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class Yarn {
  static Future<void> install(ProjectController controller) async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();
    final String? command = whichSync('yarn',
        environment: (Platform.isWindows)
            ? null
            : <String, String>{'PATH': PathEnv.get()});

    try {
      controller.isIntalling = true;
      final Process process = await Process.start(
        command!,
        <String>['install'],
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: controller.path,
        runInShell: true,
      );

      final Stream<String> outputStream = process.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final String line in outputStream) {
        outputbuffer.writeln(line);
      }

      final Stream<String> errorStream = process.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      await for (final String line in errorStream) {
        errorBuffer.writeln(line);
      }
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    } finally {
      controller.isIntalling = false;
      if (errorBuffer.toString().isNotEmpty) {
        Get.snackbar(
          'Warning Logs',
          errorBuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: SnackDismissDirection.HORIZONTAL,
        );
      } else {
        Get.snackbar(
          'Output Logs',
          outputbuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: SnackDismissDirection.HORIZONTAL,
        );
      }
    }
  }

  static Future<void> cms(ProjectController controller) async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();
    final String? command = whichSync('yarn',
        environment: (Platform.isWindows)
            ? null
            : <String, String>{'PATH': PathEnv.get()});

    try {
      controller.canKillAll = true;
      final Process process = await Process.start(
        command!,
        <String>['cms'],
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: controller.path,
        runInShell: true,
      );

      final Stream<String> outputStream = process.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final String line in outputStream) {
        outputbuffer.writeln(line);
      }

      final Stream<String> errorStream = process.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      await for (final String line in errorStream) {
        errorBuffer.writeln(line);
      }
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    } finally {
      controller.isIntalling = false;
      if (errorBuffer.toString().isNotEmpty) {
        Get.snackbar(
          'Warning Logs',
          errorBuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: SnackDismissDirection.HORIZONTAL,
        );
      } else {
        Get.snackbar(
          'Output Logs',
          outputbuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: SnackDismissDirection.HORIZONTAL,
        );
      }
    }
  }
}
