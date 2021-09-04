import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class WebiInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final String command2;
  late final List<String> args2;
  late final String path2;

  final WizardController wctrl = Get.find<WizardController>();

  WebiInstall() : super() {
    command = 'webi';
    if (Platform.isWindows) {
      command1 = 'curl.exe';
      args1 = <String>['-A', '"MS"', 'https://webinstall.dev/webi'];
      command2 = 'powershell.exe';
    } else {
      command1 = 'curl';
      args1 = <String>['-sS', 'https://webinstall.dev/webi'];
      command2 = 'bash';
      args2 = <String>[];
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
      wctrl.webiInstalled = true;
    } else {
      final CommandController ctrl = Get.find<CommandController>();
      ctrl.isLoading = true;
      if (Platform.isWindows) {
        await InstallOnWindows(onDone: onDone);
      } else {
        try {
          await Cmd.pipeTo(
            command1: command1,
            args1: args1,
            command2: command2,
            args2: args2,
          );

          installed = true;
          onDone(installed);
        } catch (e, stacktrace) {
          CommandFailedException.log(e.toString(), stacktrace.toString());
        }
      }
    }
  }

  Future<void> InstallOnWindows(
      {required Function(bool installed) onDone}) async {
    Process.run(
      'curl.exe',
      <String>[
        '-A',
        'MS',
        'https://webinstall.dev/webi',
      ],
      runInShell: true,
      // environment: <String, String>{'PATH': PathEnv.get()},
    ).asStream().listen((ProcessResult data) {
      try {
        if (data.stderr is String &&
            data.stderr.toString().contains('''
            Could not resolve host: webinstall.dev
            '''
                .trim())) {
          throw const ProcessException(
            'curl.exe',
            <String>[
              '-A',
              'MS',
              'https://webinstall.dev/webi',
            ],
          );
        } else {
          Process.run(
            'powershell.exe',
            <String>[
              '-command',
              data.stdout.toString().trim(),
            ],
            // runInShell: true,
          ).asStream().listen((ProcessResult data) {
            if (data.stdout is String) {
              onDone(true);
            }
            if (data.stderr is String && data.stderr.toString() != '') {
              CommandFailedException.log(
                  'Command Failed', data.stderr.toString());
            }
          });
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
