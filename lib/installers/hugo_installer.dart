import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class HugoInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;

  final CommandController ctrl = Get.put(CommandController());
  final WizardController wctrl = Get.put(WizardController());

  HugoInstall() : super() {
    command = 'hugo';
    if (Platform.isWindows) {
      command1 = 'scoop';
      args1 = <String>['install', 'hugo-extended'];
    } else if (Platform.isMacOS) {
      command1 = 'brew';
      args1 = <String>['install', 'hugo'];
    } else {
      command1 = 'curl';
      args1 = <String>['-sS', 'https://webinstall.dev/hugo'];
    }
  }

  Future<void> call(
      {required Function(CommandController ctrl, bool installed)
          onDone}) async {
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});

    // ignore: avoid_bool_literals_in_conditional_expressions
    bool installed = cmdPathOrNull != null ? true : false;

    if (installed == true) {
      wctrl.hugoInstalled = true;
    } else {
      ctrl.isLoading = true;

      if (Platform.isWindows) {
        InstallOnWindows();
      } else {
        final Cmd cmd = Cmd(command: command1, args: args1);

        await cmd.execute(onResult: (
          CommandController ctrl,
          String output,
        ) {
          if (output.isNotEmpty) {
            installed = true;
          }
        });
      }

      ctrl.isLoading = false;
    }
    onDone(ctrl, installed);
  }

  void InstallOnWindows() {
    Process.run(
      command1,
      args1,
      runInShell: true,
      // script is not found when this is added
    ).asStream().listen((ProcessResult data) {
      ctrl.results = data.stdout.toString();
      Process.run(
        'hugo',
        <String>['version'],
        runInShell: true,
      ).asStream().listen((ProcessResult data) {
        final String? version = Cmd.version(data.stdout.toString());
        if (version != null) {
          wctrl.hugoInstalled = true;
          Get.defaultDialog(
              title: 'Step #3 Done:',
              middleText: 'Hugo V$version is Installed',
              confirm: TextButton(
                onPressed: () {
                  Get.back();
                },
                child: const Text('OK'),
              ));
        }
      });
      try {
        if (data.stderr is String &&
            data.stderr.toString().contains('''
            The remote name could not be resolved:'''
                .trim())) {
          throw const ProcessException(
            'scoop',
            <String>[
              'install',
              'hugo-extended',
            ],
          );
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
