import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class HugoInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final CommandController ctrl;

  HugoInstall() : super() {
    command = 'hugo';
    //TODO: Review we are overriding it on call, so better remove either one
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
    final CommandController ctrl = Get.put(CommandController());
    final String fallback = p.join(
      PC.userDirectory,
      '.local',
      'bin',
    );
    final List<String> paths = <String>['/opt/homebrew/bin'];
    // TODO: this will change on platform also
    bool installed = false;
    // path for hugo
    final String? path = await PathHelper.existInPATH(
      command: command,
      paths: paths,
      fallback: fallback,
    );
    if (path != null) {
      final String cmd = '$path/$command';
      installed = await File(cmd).exists();
    } else {
      if (installed == false) {
        ctrl.isLoading = true;

        final String fallback1 = p.join('/usr', 'bin');

        final String path1 =
            await PathHelper.resolve(paths: <String>[], fallback: fallback1);

        final Cmd cmd = Cmd(command: command1, args: args1, path: path1);
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
    }
    onDone(ctrl, installed);
  }
}
