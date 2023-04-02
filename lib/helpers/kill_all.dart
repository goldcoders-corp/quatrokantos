// ignore_for_file: cascade_invocations

import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class KillAll {
  KillAll({required this.unixCmd, required this.winCmd}) : super() {
    if (Platform.isWindows) {
      command = 'taskkill';
      args.add('/F');
      args.add('/IM');
      args.add(winCmd);
    } else {
      command = 'killall';
      args.add(unixCmd);
    }
  }
  late String command;
  final String unixCmd;
  final String winCmd;
  late List<String> args = <String>[];

  Future<String> call() async {
    final outputbuffer = StringBuffer();

    final errorStrBuffer = StringBuffer();

    final process = await Process.start(command, args);

    final outputStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in outputStream) {
      outputbuffer.write('$line\n');
    }
    final errorStream = process.stderr
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in errorStream) {
      errorStrBuffer.write('$line\n');
    }
    final exitCode = await process.exitCode;

    final error = errorStrBuffer.toString().strip();
    var output = outputbuffer.toString().strip();

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
