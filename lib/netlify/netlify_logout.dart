import 'dart:convert';
import 'dart:io';

import 'package:process_run/which.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class NetlifyLogout {
  NetlifyLogout() : super() {
    command = whichSync('netlify');
    args = <String>['logout'];
  }
  late final String? command;
  late List<String> args = <String>[];

  Future<String> call() async {
    final outputbuffer = StringBuffer();
    final errorBuffer = StringBuffer();

    try {
      if (command == null) {
        throw CommandFailedException();
      } else {
        final process = await Process.start(
          command!,
          args,
          runInShell: true,
          environment: (Platform.isWindows)
              ? null
              : <String, String>{'PATH': PathEnv.get()},
        );

        final outputStream = process.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in outputStream) {
          outputbuffer.write('$line\n');
        }
      }
    } on CommandFailedException catch (e) {
      errorBuffer.write(e.toString());
    } on ProcessException catch (e) {
      errorBuffer.write(e.message);
    }

    final error = errorBuffer.toString();
    final output = outputbuffer.toString();

    if (error.isNotEmpty) {
      return error;
    } else {
      return output;
    }
  }
}
