import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class NetlifyInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final CommandController ctrl;

  NetlifyInstall() : super() {
    command = 'netlify';
    command1 = 'npm';
    args1 = <String>['install', 'netlify-cli', '-g'];
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

    if (installed == false) {
      ctrl.isLoading = true;

      final Cmd cmd = Cmd(command: command1, args: args1);
      await cmd.execute(onResult: (
        CommandController ctrl,
        String output,
      ) {
        if (output.isNotEmpty) {
          installed = true;
        }
      });

      ctrl.isLoading;
    }

    onDone(ctrl, installed);
  }
}
