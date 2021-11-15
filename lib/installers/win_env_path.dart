import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class WinEnvPaths {
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final String command2;
  late final List<String> args2;
  late final String path2;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  WinEnvPaths() : super() {
    if (Platform.isWindows) {
      command1 = 'curl';
      args1 = <String>[
        'https://gist.githubusercontent.com/goldcoders/2af44c16da58b215481d07f7601feb9a/raw/d9f10d81566a51c4ed69e50f6046d072ddc08412/refreshenv.cmd',
        '>>',
        '${PC.userDirectory}/.local/bin/refreshenv.cmd',
      ];
      command2 = 'cmd';
    }
  }

  Future<void> call({required Function(bool installed) onDone}) async {
    await _injectPath(onDone: onDone);
  }

  Future<void> _injectPath({required Function(bool installed) onDone}) async {
    final String envpath = PathEnv.get();
    // Enable powershell script execution
    await Process.run('powershell', <String>[
      'Set-ExecutionPolicy',
      '-ExecutionPolicy',
      'Unrestricted',
      '-Scope',
      'CurrentUser',
    ]);
    // Inject envpath to the User Path Env Variable
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
          await Process.run('powershell', <String>[
            r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
          ]);
          await _downloadRefreshEnvScript();
        });
      }
    });
  }

  Future<void> _downloadRefreshEnvScript() async {
    Process.run(
      'curl',
      <String>[
        'https://gist.githubusercontent.com/goldcoders/2af44c16da58b215481d07f7601feb9a/raw/d9f10d81566a51c4ed69e50f6046d072ddc08412/refreshenv.cmd',
        '>>',
        '${PC.userDirectory}\\.local\\bin\\refreshenv.cmd',
      ],
      runInShell: true,
      workingDirectory: PC.userDirectory,
    ).asStream().listen((ProcessResult data) {
      try {
        if (data.stderr is String &&
            data.stderr.toString().contains('''
            Could not resolve host: gist.githubusercontent.com
            '''
                .trim())) {
          throw ProcessException(
            'curl',
            <String>[
              'https://gist.githubusercontent.com/goldcoders/2af44c16da58b215481d07f7601feb9a/raw/d9f10d81566a51c4ed69e50f6046d072ddc08412/refreshenv.cmd',
              '>>',
              '${PC.userDirectory}\\.local\\bin\\refreshenv.cmd',
            ],
          );
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
