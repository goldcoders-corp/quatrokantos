import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/pkg_manager.dart';

class NodeInstall {
  late final String command;
  late String command1;
  late final List<String> args1;
  late final String path1;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  NodeInstall() : super() {
    command = 'node';
    command1 = PackageManager.get();
    if (Platform.isWindows) {
      args1 = <String>['install', 'nodejs-lts'];
    } else if (Platform.isMacOS) {
      // args1 = <String>['install', 'node@14'];
      command1 = 'webi';
      args1 = <String>['node@14.17.1'];
    } else {
      args1 = <String>['install', 'node'];
    }
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
      wctrl.nodeInstalled = true;
    } else {
      ctrl.isLoading = true;
      if (Platform.isWindows) {
        await _installOnWindows(onDone: onDone);
      } else {
        final Cmd cmd = Cmd(command: command1, args: args1, runInShell: true);

        await cmd.execute(onResult: (
          String output,
        ) {
          onDone(true);
        });
      }
    }
  }

  Future<void> _installOnWindows(
      {required Function(bool installed) onDone}) async {
    Process.run(
      command1,
      args1,
      runInShell: true,
    ).asStream().listen((ProcessResult data) {
      ctrl.results = data.stdout.toString();
      Process.run(
        command,
        <String>['-v'],
        runInShell: true,
        workingDirectory: PC.userDirectory,
      ).asStream().listen((ProcessResult data) {
        final String? version = Cmd.version(data.stdout.toString());

        if (version != null) {
          onDone(true);
        }
      });
      try {
        if (data.stderr is String &&
            data.stderr.toString().contains('''
            The remote name could not be resolved:'''
                .trim())) {
          throw ProcessException(
            command,
            args1,
          );
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
