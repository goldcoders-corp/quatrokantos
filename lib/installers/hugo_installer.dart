import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell_run.dart';
import 'package:process_run/which.dart';
import 'package:tint/tint.dart';

class HugoInstall {
  late final String? command1;
  late final String? command2;
  late List<String> args1 = <String>[];
  late List<String> args2 = <String>[];

  late final int exitCode;
  late final String? message;

  Future<Map<String, dynamic>> call() async {
    final String? hugo = whichSync('hugo');

    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();

    String error;
    String output;

    if (Platform.isWindows) {
      command1 = whichSync('scoop');
      args1 = <String>['install', 'hugo'];
      args2 = <String>[];
    } else if (Platform.isMacOS) {
      command1 = whichSync('brew');
      args1 = <String>['install', 'hugo'];
      args2 = <String>[];
    } else {
      command1 = whichSync('curl');
      args1 = <String>['-sS', 'https://webinstall.dev/hugo'];
      command2 = 'bash';
      args2 = <String>[];
    }

    if (hugo == null) {
      try {
        if (command1 != null) {
          final Process process = await Process.start(command1!, args1);

          final Stream<String> outputStream = process.stdout
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());
          await for (final String line in outputStream) {
            outputbuffer.write('$line\n');
          }

          final Stream<String> errorStream = process.stderr
              .transform(const Utf8Decoder())
              .transform(const LineSplitter());
          await for (final String line in errorStream) {
            errorBuffer.write('$line\n');
          }
        }
      } on ProcessException catch (e) {
        errorBuffer.write(e.message);
      }
    }
    error = errorBuffer.toString();
    output = outputbuffer.toString().strip();

    if (error.isNotEmpty) {
      exitCode = 2;
      error = error;
      message = 'Error Occured';
    } else if (output.isNotEmpty) {
      exitCode = 0;
      message = 'Hugo Installed';
      output = output;
    } else {
      exitCode = 0;
      message = 'You Already Have It Installed on Your System!';
    }
    return <String, dynamic>{
      'exitCode': exitCode,
      'output': output,
      'message': message,
    };
  }
}
