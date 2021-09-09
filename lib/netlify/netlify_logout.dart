import 'dart:convert';
import 'dart:io';

import 'package:process_run/which.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';

class NetlifyLogout {
  late final String? command;
  late List<String> args = <String>[];

  NetlifyLogout() : super() {
    command = whichSync('netlify');
    args = <String>['logout'];
  }

  Future<String> call() async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();

    try {
      if (command == null) {
        throw CommandFailedException();
      } else {
        final Process process = await Process.start(command!, args);

        final Stream<String> outputStream = process.stdout
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

    final String error = errorBuffer.toString();
    final String output = outputbuffer.toString();

    if (error.isNotEmpty) {
      return error;
    } else {
      return output;
    }
  }
}
