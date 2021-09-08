import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:tint/tint.dart';

class NpmRun {
  late final String? command;
  final String path;
  late List<String> args = <String>[];

  NpmRun({required this.path, required this.args}) : super() {
    // change Directory
    // Must Be Only Run Inside Project Page
    command = whichSync('npm');
    PathHelper.exists(path).then((bool exists) {
      if (exists == true) {
        Directory.current = path;
      }
    });
    args = args;
  }

  Future<String> call() async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer breakBuffer = StringBuffer();
    final StringBuffer missingBuffer = StringBuffer();
    final StringBuffer errorStrBuffer = StringBuffer();
    final StringBuffer portBuffer = StringBuffer();

    final RegExp missingScriptRegex = RegExp(r'(?<=missing\sscript:).*?\n');
    final RegExp CtrlCRegex = RegExp(r'\bPress\sCtrl\+C\sto\sstop\b');
    final RegExp PortRegex = RegExp(r'\bEADDRINUSE\b');

    try {
      if (command == null) {
        throw CommandFailedException();
      } else {
        final Process process = await Process.start(command!, args);

        final Stream<String> outputStream = process.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in outputStream) {
          if (CtrlCRegex.hasMatch('$line\n')) {
            breakBuffer.write(
                'Open Browser at: http://localhost:1313 & http://localhost:1234');
            break;
          }
          outputbuffer.write('$line\n');
        }
        final String exitEarly = breakBuffer.toString().strip();
        if (exitEarly.isNotEmpty) {
          return exitEarly;
        }
        final Stream<String> errorStream = process.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in errorStream) {
          if (missingScriptRegex.hasMatch('$line\n')) {
            missingBuffer.write('$line\n');
            print('im triggered');
            process.kill();
            break;
          } else if (PortRegex.hasMatch(line)) {
            portBuffer
                .write('Please Stop Server First Before Running this Command');
            process.kill();
            break;
          }
          errorStrBuffer.write('$line\n');
        }
      }
    } on CommandFailedException catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    } on ProcessException catch (e) {
      errorStrBuffer.write(e.message);
    }

    final String error = errorStrBuffer.toString().strip();
    final String missingScript = missingBuffer.toString().strip();
    final String portError = portBuffer.toString();
    if (missingScript.isNotEmpty) {
      return 'NPM Script $missingScript is Missing';
    } else if (portError.isNotEmpty) {
      return portError;
    } else {
      if (error.isNotEmpty) {
        return error;
      } else {
        return 'Undefined Error';
      }
    }
  }
}
