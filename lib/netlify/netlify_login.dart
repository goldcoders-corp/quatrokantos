import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';

class NetlifyLogged {
  late final CommandController ctrl;
  late final WizardController wizard;
  final String command = 'netlify';
  late final List<String> args;

  NetlifyLogged() : super() {
    args = <String>['login'];
  }

  Future<void> call({
    required Function(
      bool logged,
    )
        onDone,
  }) async {
    ctrl = Get.put(CommandController());
    wizard = Get.put(WizardController());

    if (wizard.netlifyLogged == false) {
      ctrl.isLoading = true;
      final Cmd cmd = Cmd(command: command, args: args, path: '');
      cmd.execute(onResult: (CommandController ctrl, String output) {
        onDone(true);
        Get.snackbar('Netlify Login', output);
      });
    } else {
      onDone(true);
      Get.snackbar('Netlify Login', 'Already Logged In');
    }
  }
}
