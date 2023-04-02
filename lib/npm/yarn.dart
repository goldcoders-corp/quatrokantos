// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

// import 'package:flutter/services.dart';
import 'package:archive/archive.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class Yarn {
  static Future<void> install(ProjectController controller) async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();
    final String? command = whichSync('yarn',
        environment: (Platform.isWindows)
            ? null
            : <String, String>{'PATH': PathEnv.get()});
    // we can use this at the end of the wizard installation
    // so we can force user to quit the app and open again.
    // SystemNavigator.pop();
    // create a new repo for all our scripts
    // download the repo
    // extract
    // save to .local/bin/
    // run the script
    // exit the app
    // then open the app again
    // we should export all path in .zshrc
    // this is to allow us to execute the scripts
    // if running on linux we should also
    // update permissions of the scripts to be executable
    // final String script =
    //     await rootBundle.loadString('assets/scripts/example.sh');

    // final Shell shell = Shell(
    //     workingDirectory: PC.userDirectory,
    //     environment: <String, String>{'PATH': PathEnv.get()});
    // shell.run(
    //   script,
    // );
    // This is an example if we wanted to ship default theme zip file
    // so we can avoid downloading it
    // we can then save the file to the cms or themes directory
    final ByteData zipFile =
        await rootBundle.load('assets/scripts/goldcoders.dev.zip');
    final List<int> bytes = Uint8List.view(zipFile.buffer);
    final Archive archive = ZipDecoder().decodeBytes(bytes);
    final String destination =
        p.join(PC.userDirectory, '.local', 'share', 'archives');
    for (final ArchiveFile file in archive) {
      String filename = file.name;
      final RegExp regExp = RegExp(r'\/(.*)');
      filename = regExp.stringMatch(filename)!;
      if (file.isFile) {
        if (kDebugMode) {
          print(file.name);
        }
        final List<int> data = file.content as List<int>;

        File(destination + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(destination + filename).create(recursive: true);
      }
    }

    /// This is not working...
    if (command == null) {
      if (Platform.isMacOS) {
        await Process.run(
          'source',
          <String>['.zshrc'],
          environment: <String, String>{'PATH': PathEnv.get()},
          workingDirectory: PC.userDirectory,
        );
        await Process.run(
          'source',
          <String>['.zprofile'],
          environment: <String, String>{'PATH': PathEnv.get()},
          workingDirectory: PC.userDirectory,
        );
      }
    }
    try {
      controller.isIntalling = true;
      final Process process = await Process.start(
        command!,
        <String>['install'],
        environment: (Platform.isWindows)
            ? null
            : <String, String>{'PATH': PathEnv.get()},
        workingDirectory: controller.path,
        // ignore: avoid_bool_literals_in_conditional_expressions
        runInShell: Platform.isWindows ? true : false,
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
          dismissDirection: DismissDirection.horizontal,
        );
      } else {
        Get.snackbar(
          'Output Logs',
          outputbuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: DismissDirection.horizontal,
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
        environment: (Platform.isWindows)
            ? null
            : <String, String>{'PATH': PathEnv.get()},
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
          dismissDirection: DismissDirection.horizontal,
        );
      } else {
        Get.snackbar(
          'Output Logs',
          outputbuffer.toString(),
          duration: const Duration(seconds: 5),
          dismissDirection: DismissDirection.horizontal,
        );
      }
    }
  }
}
