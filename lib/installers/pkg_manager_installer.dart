import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class PkgMangerInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;

  late final String command2;
  late final List<String> args2;

  late final CommandController ctrl;

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
      command1 = 'bash';
      args1 = <String>[
        '-c',
        '''
      "\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'''
            .trim()
      ];
      command2 = '';
      args2 = <String>[];
    }
  }

  Future<void> call(
      {required Function(CommandController ctrl, bool installed)
          onDone}) async {
    final CommandController ctrl = Get.put(CommandController());
    bool installed = false;
    final String? pathExists = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});
    if (pathExists != null) {
      installed = true;
    }
    print('mypath: $pathExists');

    if (installed == false) {
      ctrl.isLoading = true;
      try {
        await Cmd.pipeTo(
          command1: command1,
          args1: args1,
          command2: command2,
          args2: args2,
        );

        installed = true;
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }

      ctrl.isLoading;

      onDone(ctrl, installed);
    } else {
      onDone(ctrl, installed);
    }
  }
}
