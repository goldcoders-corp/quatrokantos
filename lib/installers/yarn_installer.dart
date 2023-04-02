import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class YarnInstaller {
  YarnInstaller() : super() {
    command = 'yarn';
    command1 = 'npm';
    args1 = <String>['install', '-g', 'yarn', '--force'];
  }
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  // ignore: inference_failure_on_function_return_type
  Future<void> call({required Function(bool installed) onDone}) async {
    final cmdPathOrNull = whichSync(
      command,
      environment:
          (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()},
    );

    bool installed;
    if (cmdPathOrNull != null) {
      installed = true;
    } else {
      installed = false;
    }

    if (installed == true) {
      wctrl.netlifyInstalled = true;
    } else {
      ctrl.isLoading = true;

      await _install(onDone: onDone);
    }
  }

  // ignore: inference_failure_on_function_return_type
  Future<void> _install({required Function(bool installed) onDone}) async {
    final env =
        (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()};
    final cmdPathOrNull = whichSync(command1, environment: env);

    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args1,
          runInShell: true,
          environment: env,
        ).asStream().listen(
          (ProcessResult process) async {
            if (kDebugMode) {
              print(process.stdout);
              print(process.stderr);
            }
          },
          onDone: () {
            onDone(true);
          },
        );
      } catch (e, stacktrace) {
        await CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      await CommandFailedException.log(
        'Command Not Found',
        'NodeJS is not yet Installed',
      );
      onDone(false);
    }
  }
}
