import 'dart:io';

import 'package:get/get.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';

/// #### Open Any URL with the Default Browser
/// #### Just Create New Instance passing the URL
/// #### then invoke `()` or `call()` method
class UrlLauncher {
  final String url;

  const UrlLauncher({required this.url});

  String _getOpenCMD() {
    if (Platform.isMacOS) {
      return 'open';
    } else if (Platform.isWindows) {
      return 'explorer.exe';
    } else {
      return 'xdg-open';
    }
  }

  List<String> _getArgs(String url) {
    return <String>[url];
  }

  /// Quickly Launch Text Editor
  Future<void> call() async {
    final String command = _getOpenCMD();
    final List<String> args = _getArgs(url);
    Get.put(CommandController());
    await Cmd.open(command: command, args: args);
  }
}
