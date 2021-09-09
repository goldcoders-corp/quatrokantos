import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class WebiInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final String command2;
  late final List<String> args2;
  late final String path2;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  WebiInstall() : super() {
    command = 'webi';
    if (Platform.isWindows) {
      command1 = 'curl';
      args1 = <String>['-A', '"MS"', 'https://webinstall.dev/webi'];
      command2 = 'powershell';
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
      ctrl.isLoading = true;
      if (Platform.isWindows) {
        await _injectPath(onDone: onDone);
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
          CommandFailedException.log(e.toString(), stacktrace.toString());
        }
      }
    }
  }

  Future<void> _injectPath({required Function(bool installed) onDone}) async {
    final String envpath = PathEnv.get();
    if (Platform.isWindows) {
      Process.run(
        'powershell',
        <String>[
          '-command',
          '[Environment]::GetEnvironmentVariable("PATH", "User")',
        ],
        runInShell: true,
        workingDirectory: PC.userDirectory,
      ).asStream().listen((ProcessResult process) async {
        if (process.stdout is String) {
          Process.run(
            'powershell',
            <String>[
              '-command',
              '''
[Environment]::SetEnvironmentVariable("PATH", "${process.stdout.toString().trim()};$envpath","User")
''',
            ],
            runInShell: true,
            workingDirectory: PC.userDirectory,
          ).asStream().listen((ProcessResult process) async {
            await _installOnWindows(onDone: onDone);
          });
        }
      });
    }
  }

  Future<void> _installOnWindows(
      {required Function(bool installed) onDone}) async {
    Process.run(
      'curl',
      <String>[
        '-A',
        'MS',
        'https://webinstall.dev/webi',
        '>>',
        '${PC.userDirectory}\\Downloads\\install_webi.ps1',
      ],
      runInShell: true,
      workingDirectory: PC.userDirectory,
    ).asStream().listen((ProcessResult process1) {
      try {
        if (process1.stderr is String &&
            process1.stderr.toString().contains('''
            Could not resolve host: webinstall.dev
            '''
                .trim())) {
          throw ProcessException(
            'curl',
            <String>[
              '-A',
              'MS',
              'https://webinstall.dev/webi',
              '>>',
              '${PC.userDirectory}\\Downloads\\install_webi.ps1',
            ],
          );
        } else {
          Process.run(
            'powershell',
            <String>[
              '-command',
              '${PC.userDirectory}\\Downloads\\install_webi.ps1',
            ],
            runInShell: true,
            workingDirectory: PC.userDirectory,
          ).asStream().listen((ProcessResult process2) {
            if (process2.stdout is String) {
              onDone(true);
            }
            if (process2.stderr is String && process2.stderr.toString() != '') {
              CommandFailedException.log(
                  'Command Failed', process2.stderr.toString());
            }
          });
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
