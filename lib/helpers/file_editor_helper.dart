import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/cmd_helper.dart';

/// #### Open Any File with the Default Text Editor
/// #### Just Create New Instance passing absolutePath of a file
/// #### then invoke `open()` method
class FileEditor {
  late final String _filePath;

  FileEditor({required String filePath}) : _filePath = filePath;

  String get filePath => _filePath;

  set filePath(String f) => _filePath = f;

  static const String macOs = 'open';
  static const String windows = 'notepad.exe';
  static const String linux = '\$EDITOR';

  /// Quickly Launch Text Editor
  Future<void> open() async {
    final List<String> args = <String>[];
    String command = '';

    if (Platform.isWindows) {
      // notepad.exe "C:\Documents\File.txt"
      final p.Context context = p.Context(style: p.Style.windows);
      final String winPath = context.join(dir(), filename());
      args.add(winPath);
      command = windows;
    } else if (Platform.isMacOS) {
      // open -a TextEdit ./$filename
      args.add('-a');
      args.add('TextEdit');
      args.add(filePath);
      command = macOs;
    } else {
      // $EDITOR ./filename
      args.add(filePath);
      command = linux;
    }
    await Cmd.open(command: command, args: args);
  }

  String dir() {
    final Directory absolutePath = Directory(filePath);
    final String dir = absolutePath.parent.path;
    return dir;
  }

  String filename() {
    return filePath.split('/').last;
  }
}
