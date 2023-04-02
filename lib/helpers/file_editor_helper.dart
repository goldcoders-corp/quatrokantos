// ignore_for_file: depend_on_referenced_packages, unnecessary_getters_setters, cascade_invocations, lines_longer_than_80_chars

import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/cmd_helper.dart';

/// #### Open Any File with the Default Text Editor
/// #### Just Create New Instance passing absolutePath of a file
/// #### then invoke `open()` method
class FileEditor {
  FileEditor({required String filePath}) : _filePath = filePath;
  late final String _filePath;

  String get filePath => _filePath;

  set filePath(String f) => _filePath = f;

  static const String macOs = 'open';
  static const String windows = 'notepad.exe';
  static const String linux = r'$EDITOR';

  /// Quickly Launch Text Editor
  Future<void> open() async {
    final args = <String>[];
    var command = '';

    if (Platform.isWindows) {
      // notepad.exe "C:\Documents\File.txt"
      final context = p.Context(style: p.Style.windows);
      final winPath = context.join(dir(), filename());
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
    final absolutePath = Directory(filePath);
    final dir = absolutePath.parent.path;
    return dir;
  }

  String filename() {
    return filePath.split('/').last;
  }
}
