import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class YarnInstaller {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  YarnInstaller() : super() {
    command = 'yarn';
    command1 = 'npm';
    args1 = <String>['install', '-g', 'yarn', '--force'];
  }

  Future<void> call({required Function(bool installed) onDone}) async {
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});

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

      _install(onDone: onDone);
    }
  }

  Future<void> _install({required Function(bool installed) onDone}) async {
    final String? cmdPathOrNull = whichSync(command1,
        environment: <String, String>{'PATH': PathEnv.get()});
    if (cmdPathOrNull != null) {
      try {
        Process.run(
          cmdPathOrNull,
          args1,
          runInShell: true,
        ).asStream().listen((ProcessResult process) async {
          print(process.stdout);
          print(process.stderr);
        }, onDone: () {
          onDone(true);
        });
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    } else {
      CommandFailedException.log(
          'Command Not Found', 'NodeJS is not yet Installed');
      onDone(false);
    }
  }
}
