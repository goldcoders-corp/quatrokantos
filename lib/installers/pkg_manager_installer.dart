import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class PkgMangerInstall {
  PkgMangerInstall() : super() {
    if (Platform.isWindows) {
      command = 'scoop';
      command1 = 'powershell.exe';
      args1 = <String>[
        '-command',
        'Set-ExecutionPolicy',
        'RemoteSigned',
        '-scope',
        'CurrentUser'
      ];
      command2 = 'powershell.exe';
      args2 = <String>[
        '-command',
        'iwr -useb get.scoop.sh',
        '|',
        'iex',
      ];
    } else {
      command = 'brew';
      command1 = 'curl';
      args1 = <String>['-sS', 'https://webinstall.dev/brew'];
      command2 = 'bash';
      args2 = <String>[];
    }
  }
  late final String command;
  late final String command1;
  late final List<String> args1;

  late final String command2;
  late final List<String> args2;

  final CommandController ctrl = Get.find<CommandController>();
  final WizardController wctrl = Get.find<WizardController>();

  // ignore: inference_failure_on_function_return_type
  Future<void> call({required Function(bool installed) onDone}) async {
    final cmdPathOrNull = whichSync(
      command,
      environment: <String, String>{'PATH': PathEnv.get()},
    );
    bool installed;
    if (cmdPathOrNull != null) {
      installed = true;
    } else {
      installed = false;
    }

    if (installed == true) {
      wctrl.pkgInstalled = true;
    } else {
      ctrl.isLoading = true;
      if (Platform.isWindows) {
        await _installOnWindows(onDone: onDone);
      } else {
        try {
          await Cmd.pipeTo(
            command1: command1,
            args1: args1,
            command2: command2,
            args2: args2,
            onDone: onDone,
          );
        } catch (e, stacktrace) {
          await CommandFailedException.log(e.toString(), stacktrace.toString());
        }
      }
    }
  }

  Future<void> _installOnWindows({
    // ignore: inference_failure_on_function_return_type
    required Function(bool installed) onDone,
  }) async {
    Process.run(
      'powershell',
      <String>[
        '-command',
        'Set-ExecutionPolicy',
        'RemoteSigned',
        '-scope',
        'CurrentUser',
      ],
      workingDirectory: PC.userDirectory,
      runInShell: true,
    ).asStream().listen((ProcessResult data) {
      Process.run(
        'powershell',
        <String>[
          '-command',
          '''
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')
'''
              .trim(),
        ],
        workingDirectory: PC.userDirectory,
        runInShell: true,
      ).asStream().listen((ProcessResult process) {
        try {
          if (process.stderr is String &&
              process.stderr.toString().contains(
                    '''
The remote name could not be resolved:
'''
                        .trim(),
                  )) {
            throw const ProcessException(
              'powershell.exe',
              <String>[
                '-command',
                '''
Invoke-Expression (New-Object System.Net.WebClient).DownloadString('https://get.scoop.sh')''',
              ],
            );
          }
          if (process.stdout is String) {
            onDone(true);
          }
        } catch (e, stacktrace) {
          CommandFailedException.log(e.toString(), stacktrace.toString());
        }
      });
    });
  }
}
