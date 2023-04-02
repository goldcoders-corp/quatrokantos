// ignore_for_file: omit_local_variable_types

import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/result_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

mixin Installer {
  /// Command to be used on each Class
  late final String cmd;

  /// Can be Set to Change Current Working Directory
  String workingDirectory = PC.userDirectory;

  /// Arguments to be passed to the Command
  List<String> args = <String>[];

  /// Get the Current Platform
  String platform = PC.os;

  /// Useful for Windows , it will launch CMD
  bool runInShell = Platform.isWindows;

  /// Use to Pipe Stdout to another command
  bool pipeCommand = false;

  /// Use to Listen to Stream of Stdout and Stderr
  bool listenToStream = false;

  /// Our Exitcode
  int exitcode = 0;

  /// Stdout of the command
  String? stdout;

  /// Stderr of the command
  String? stderr;

  String? version;

  ResultController controller = Get.find<ResultController>();

  /// ENV PATH to be used, on windows we dont need these
  Map<String, String>? environment =
      (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()};

  String? cmdPathOrNull() {
    final String? command = whichSync(cmd, environment: environment);
    if (command != null) {
      return cmd = command;
    } else {
      return null;
    }
  }

  void run() {
    try {
      if (cmdPathOrNull() == null) {
        Process.run(
          cmd,
          args,
          runInShell: runInShell,
          environment: environment,
          workingDirectory: workingDirectory,
        ).asStream().listen(
          (ProcessResult data) {
            if (listenToStream) {
              // pipe to controller with stream
              controller
                ..results = data.stdout.toString()
                ..errors = data.stderr.toString();
            }
            // set current version to local storage
            // set command path to local storage
          },
          onDone: () {
            // refreshCMD
          },
          onError: (Object e) {
            // Throw Error
            throw ProcessException(cmd, args, e.toString(), exitCode = 1);
          },
        );
      } else {
        throw ProcessException(cmd, args);
      }
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }
}
