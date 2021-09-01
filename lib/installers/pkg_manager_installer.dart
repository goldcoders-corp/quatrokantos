import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class PkgMangerInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final String command2;
  late final List<String> args2;
  late final String path2;

  late final CommandController ctrl;

  PkgMangerInstall() : super() {
    if (Platform.isWindows) {
      // iwr -useb get.scoop.sh | iex
      command = 'scoop';
      command1 = 'iwr';
      args1 = <String>['-useb', 'get.scoop.sh'];
      command2 = 'iex';
      args2 = <String>[];
    } else {
      command = 'brew';
      command1 = whichSync('curl')!;
      args1 = <String>['-sS', 'https://webinstall.dev/brew'];
      command2 = whichSync('bash')!;
      args2 = <String>[];
    }
  }

  Future<void> call(
      {required Function(CommandController ctrl, bool installed)
          onDone}) async {
    final CommandController ctrl = Get.put(CommandController());
    // TODO: this will change on platform also
    final String fallback =
        p.join(PC.userDirectory, '.local', 'opt', 'brew', 'bin');
    final String fallback1 = p.join('/usr', 'bin');
    final String fallback2 = p.join('/bin');
    const String command1 = 'curl';
    const String command2 = 'bash';
    bool installed = false;

    final String path =
        await PathHelper.resolve(paths: <String>[], fallback: fallback);

    final String cmd = '$path/$command';
    installed = await File(cmd).exists();

    if (installed == false) {
      ctrl.isLoading = true;

      final String path1 =
          await PathHelper.resolve(paths: <String>[], fallback: fallback1);

      final String path2 =
          await PathHelper.resolve(paths: <String>[], fallback: fallback2);

      await Cmd.pipeTo(
        command1: command1,
        args1: args1,
        path1: path1,
        command2: command2,
        args2: <String>[],
        path2: path2,
      );

      ctrl.isLoading;

      installed = true;
    }
    onDone(ctrl, installed);
  }
}
