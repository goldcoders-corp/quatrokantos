// ignore_for_file: flutter_style_todos

import 'dart:convert';
import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:tint/tint.dart';

class NpmRun {
  // ignore: todo
  // TODO (Uriah): We need this to Run as Isolate
  // Returnt the Process ID so we can Kill it anytime
  // If We Have an Existing Process Running , Dont Start
  // Ask User to Killall Process first

  NpmRun({required this.path, required this.args}) : super() {
    // change Directory
    // Must Be Only Run Inside Project Page
    command =
        whichSync('npm', environment: <String, String>{'PATH': PathEnv.get()});

    args = args;
  }
  late final String? command;
  final String path;
  late List<String> args;

  Future<String> run() async {
    final outputbuffer = StringBuffer();
    // final StringBuffer breakBuffer = StringBuffer();
    final missingBuffer = StringBuffer();
    final errorStrBuffer = StringBuffer();
    final portBuffer = StringBuffer();

    // final RegExp missingScriptRegex = RegExp(r'(?<=missing\sscript:).*?\n');
    // final RegExp CtrlCRegex = RegExp(r'\bPress\sCtrl\+C\sto\sstop\b');
    // final RegExp PortRegex = RegExp(r'\bEADDRINUSE\b');

    try {
      if (command == null) {
        throw CommandFailedException();
      } else {
        final process = await Process.start(
          command!,
          args,
          runInShell: true,
          workingDirectory: path,
          environment: (Platform.isWindows)
              ? null
              : <String, String>{'PATH': PathEnv.get()},
        );

        final outputStream = process.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in outputStream) {
          // if (CtrlCRegex.hasMatch('$line\n')) {
          //   breakBuffer.write(
          //       'Open Browser at: http://localhost:1313 & http://localhost:1234');
          //   break;
          // }
          outputbuffer.write('$line\n');
        }
        // final String exitEarly = breakBuffer.toString().strip();
        // if (exitEarly.isNotEmpty) {
        //   return exitEarly;
        // }
        final errorStream = process.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in errorStream) {
          // if (missingScriptRegex.hasMatch('$line\n')) {
          //   missingBuffer.write('$line\n');
          //   process.kill();
          //   break;
          // } else if (PortRegex.hasMatch(line)) {
          //   portBuffer
          //     .write('Please Stop Server First Before Running this Command');
          //   process.kill();
          //   break;
          // }
          errorStrBuffer.write('$line\n');
        }
      }
    } on CommandFailedException catch (e, stacktrace) {
      await CommandFailedException.log(e.toString(), stacktrace.toString());
    } on ProcessException catch (e) {
      errorStrBuffer.write(e.message);
    }

    final error = errorStrBuffer.toString().strip();
    final missingScript = missingBuffer.toString().strip();
    final portError = portBuffer.toString();
    if (missingScript.isNotEmpty) {
      return 'NPM Script $missingScript is Missing';
    } else if (portError.isNotEmpty) {
      return portError;
    } else {
      if (error.isNotEmpty) {
        return error;
      } else {
        return 'Running Command Completed'; // message usually npm audit fix
      }
    }
  }
}
