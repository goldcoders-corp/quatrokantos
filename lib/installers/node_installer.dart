import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class NodeInstall {
  late final String command;
  late final String command1;
  late final List<String> args1;
  late final String path1;

  late final CommandController ctrl;

  NodeInstall() : super() {
    command = 'node';
    //TODO: Review we are overriding it on call, so better remove either one
    command1 = 'webi';
    args1 = <String>['node'];
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
