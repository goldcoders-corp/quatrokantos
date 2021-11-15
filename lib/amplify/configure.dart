import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

/// we need to create a bash script , apple script and powershell script
/// that enter add input to the command
class AmplifyConfigure {
  // from input we pass the args to a shell script or powershell script
  // bash script
  // printf '\n
  // we need to install xdotool
  // https://askubuntu.com/questions/338857/automatically-enter-input-in-command-line
  // https://www.thegeekstuff.com/2010/10/expect-examples/
  // use xdotool
  // https://en.wikipedia.org/wiki/Expect#Basics
  final String command = 'amplify';
  final List<String> args = <String>['configure'];
  final String? cmdPathOrNull = whichSync('amplify',
      environment: <String, String>{'PATH': PathEnv.get()});

  final CommandController ctrl = Get.find<CommandController>();

  Future<void> execute({required Function(String output) onResult}) async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();

    try {
      final Process process = await Process.start(
        command,
        args,
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: cmdPathOrNull,
        runInShell: true,
      );

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
    } catch (e, stacktrace) {
      errorBuffer.write(stacktrace);
    }

    final String error = errorBuffer.toString();
    final String output = outputbuffer.toString();
    String result = '';

    try {
      if (error.isNotEmpty) {
        // Remove Throwing Exceptions on DEBUG, but we can safely remove this
        if (command != 'netlify' && args != <String>['login']) {
          throw CommandFailedException();
        }
        result = error;
      }
      if (output.isNotEmpty) {
        result = output;
      }
      onResult(result);
    } on CommandFailedException catch (e, stacktrace) {
      CommandFailedException.log(
          e.toString(), '$error\n${stacktrace.toString()}');
    }
  }

  static String? version(String output) {
    final RegExp regExp = RegExp(
      r'(\d+)\.(\d+)\.(\d+)',
    );
    return regExp.stringMatch(output).toString();
  }

  /// #### Executing Two Commands
  /// #### First Command Act as Input for 2nd Command
  /// #### Like `Unix Pipe`, They Both Work The Same way
  /// #### For Example:
  ///```
  ///final String curlPath = p.join('/usr', 'bin');
  /// final String bashPath = p.join('/bin');
  /// const String command1 = 'curl';
  /// const String command2 = 'bash';
  ///
  /// final String path1 =
  ///     await PathHelper.resolve(paths: <String>[], fallback: curlPath);
  ///
  /// final String path2 =
  ///     await PathHelper.resolve(paths: <String>[], fallback: bashPath);
  ///
  ///  await Cmd.pipeTo(
  ///   command1: command1,
  ///   args1: <String>['-sS', 'https://webinstall.dev/webi'],
  ///   path1: path1,
  ///   command2: command2,
  ///   args2: <String>[],
  ///   path2: path2,
  /// );
  ///```
  static Future<void> pipeTo(
      {required String command1,
      required List<String> args1,
      String? path1,
      required String command2,
      required List<String> args2,
      String? path2,
      required Function(bool installed) onDone}) async {
    final CommandController ctrl = Get.find<CommandController>();
    final StringBuffer outputbuffer = StringBuffer();

    try {
      final Process left = await Process.start(
        command1,
        args1,
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: path1,
        runInShell: true,
      );

      final Process right = await Process.start(
        command2,
        args2,
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: path2,
        runInShell: true,
      );

      left.stdout.pipe(right.stdin);
      right.stdout.transform(utf8.decoder).listen((String event) {
        outputbuffer.write('$event\n');
      }).onDone(() {
        ctrl.results = outputbuffer.toString();
        onDone(true);
      });
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }

  static Future<void> open({
    required String command,
    required List<String> args,
  }) async {
    final CommandController ctrl = Get.find<CommandController>();
    // final StringBuffer outputbuffer = StringBuffer();

    try {
      final Process left = await Process.start(
        command,
        args,
      );

      left.stdout.transform(utf8.decoder).listen((String event) {
        // outputbuffer.write('$event\n');
      }).onDone(() {
        ctrl.results = 'Opening Site ${args[0]}';
      });
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }
}
