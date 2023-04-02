import 'dart:io';

import 'package:quatrokantos/helpers/cmd_helper.dart';

/// #### Open Any URL with the Default Browser
/// #### Just Create New Instance passing the URL
/// #### then invoke `()` or `call()` method
class UrlLauncher {
  const UrlLauncher({required this.url});
  final String url;

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
    final command = _getOpenCMD();
    final args = _getArgs(url);

    await Cmd.open(command: command, args: args);
  }
}
