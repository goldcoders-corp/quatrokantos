import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

/// #### Open Any File with the Default Text Editor
/// #### Just Create New Instance passing absolutePath of a file
/// #### then invoke `open()` method
class Folder {
  late final String _name;

  Folder({required String name}) : _name = name;

  String get name => _name;

  set name(String f) => _name = f;

  static const String macOs = 'open';
  static const String windows = 'explorer.exe';
  static const String linux = 'xdg-open';

  String folder() {
    String appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    final ReplaceHelper text = ReplaceHelper(text: appFolder, regex: '\\s+');
    appFolder = text.replace();

    late String siteFolder;

    if (Platform.isWindows) {
      final p.Context context = p.Context(style: p.Style.windows);
      siteFolder = context.join(
          PC.userDirectory, '.local', 'share', '.$appFolder', 'sites', name);
    } else {
      final p.Context context = p.Context(style: p.Style.posix);
      siteFolder = context.join(
          PC.userDirectory, '.local', 'share', '.$appFolder', 'sites', name);
    }

    PathHelper.mkd(siteFolder);

    return siteFolder;
  }

  /// Quickly Launch Text Editor
  Future<void> open() async {
    final List<String> args = <String>[];
    late String command;

    if (Platform.isWindows) {
      command = windows;
    } else if (Platform.isMacOS) {
      command = macOs;
    } else {
      command = linux;
    }

    final String folderPath = folder();
    args.add(folderPath);
    await Cmd.open(command: command, args: args);
  }

  String cwd() {
    final Directory absolutePath = Directory(name);
    final String dir = absolutePath.parent.path;
    return dir;
  }

  String filename() {
    return name.split('/').last;
  }
}
