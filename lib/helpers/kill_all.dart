import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class KillAll {
  late String command;
  final String unix_cmd;
  final String win_cmd;
  late List<String> args = <String>[];

  KillAll({required this.unix_cmd, required this.win_cmd}) : super() {
    if (Platform.isWindows) {
      command = 'taskkill';
      args.add('/F');
      args.add('/IM');
      args.add(win_cmd);
    } else {
      command = 'killall';
      args.add(unix_cmd);
    }
  }

  Future<String> call() async {
    final StringBuffer outputbuffer = StringBuffer();

    final StringBuffer errorStrBuffer = StringBuffer();

    final Process process = await Process.start(command, args);

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
      errorStrBuffer.write('$line\n');
    }
    final int exitCode = await process.exitCode;

    final String error = errorStrBuffer.toString().strip();
    String output = outputbuffer.toString().strip();

    if (exitCode >= 1) {
      return error;
    } else {
      if (output.isEmpty) {
        output = 'Stopped the Running Process';
      }
      return output;
    }
  }
}
