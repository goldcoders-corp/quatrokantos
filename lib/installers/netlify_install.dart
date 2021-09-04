import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

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
