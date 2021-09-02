import 'dart:io';

import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

/// Define Here Path Variables
class PathEnv {
  static String get() {
    late final String path;
    late final String str;
    if (Platform.isMacOS) {
      path = '''
/bin
/sbin
/usr/bin
/usr/sbin
/usr/local/bin
/opt/homebrew/sbin
/opt/homebrew/bin
${PC.userDirectory}/.local/bin
${PC.userDirectory}/.local/opt/brew/bin
${PC.userDirectory}/.local/opt/brew/sbin
${PC.userDirectory}/.local/opt/node/bin''';
      str = ':';
    } else if (Platform.isWindows) {
      // If Windows
      path = '''
C:\\Windows
C:\\Windows\\System32
C:\\Windows\\System32\\Wbem
C:\\Windows\\System32\\WindowsPowershell\\v1.0
C:\\ProgramData\\scoop\\shims
C:\\ProgramData\\chocolatey\\bin
${PC.userDirectory}\\AppData\\Local\\Microsoft\\WindowsApps
${PC.userDirectory}\\.local\\bin
${PC.userDirectory}\\scoops\\shims
${PC.userDirectory}\\.local\\bin
${PC.userDirectory}\\.local\\opt\\node\\bin''';
      str = ';';
    } else {
      path = '''
/bin
/usr/bin
/usr/local/bin
/usr/local/sbin
${PC.userDirectory}/.local/opt/node/bin
${PC.userDirectory}/.local/bin''';
      str = ':';
    }

    return ReplaceHelper(text: path, str: str, regex: '\n+').replace();
  }
}
