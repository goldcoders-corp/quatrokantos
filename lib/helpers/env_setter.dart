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
${PC.userDirectory}/Library/Containers/dev.goldcoders.quatrokantos/Data/.local/bin
${PC.userDirectory}/.nodenv/shims
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
C:\\ProgramData\\scoop\\shims
${PC.userDirectory}\\AppData\\Local\\Microsoft\\WindowsApps
${PC.userDirectory}\\scoop\\apps\\yarn\\current\\global\\bin
${PC.userDirectory}\\.local\\bin
${PC.userDirectory}\\scoops\\shims
${PC.userDirectory}\\scoop\\apps\\nodejs-lts\\current
${PC.userDirectory}\\scoop\\apps\\nodejs-lts\\current\\bin
${PC.userDirectory}\\scoop\\apps\\nodejs\\current
${PC.userDirectory}\\scoop\\apps\\nodejs\\current\\bin
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
// All the User PATH i have
//C:\v;C:\Go\bin;C:\.hugo;C:\UnxUtils\bin;C:\UnxUtils\usr\local\wbin;C:\tools\neovim\Neovim\bin;C:\tools\openssl\bin;C:\tools\php80;C:\tools\ruby27\bin;C:\Windows;C:\Windows\system32;C:\Windows\System32\Wbem;C:\Windows\System32\WindowsPowerShell\v1.0\;C:\Windows\System32\OpenSSH\;C:\ProgramData\ComposerSetup\bin;C:\ProgramData\chocolatey\bin;C:\ProgramData\scoop\shims;C:\Program Files\dotnet\;C:\Program Files\Java\jdk1.8.0_211\bin;C:\Program Files\MySQL\MySQL Server 8.0\bin;C:\Program Files\MySQL\MySQL Shell 8.0\bin;C:\Program Files\MySQL\MySQL Workbench 8.0 CE\;C:\Program Files\NVIDIA Corporation\NVIDIA NvDLISR;C:\Program Files\PowerShell\7;C:\Program Files\Vim\vim82;C:\Program Files (x86)\Common Files\Intel\Shared Libraries\redist\intel64\compiler;C:\Program Files (x86)\GitHub CLI\;C:\Program Files (x86)\gnupg\bin;C:\Program Files (x86)\NVIDIA Corporation\PhysX\Common;C:\Users\masterpowers\AppData\Local\Android\Sdk\platform-tools;C:\Users\masterpowers\AppData\Local\Android\Sdk\emulator;C:\Users\masterpowers\AppData\Local\Android\Sdk\cmdline-tools\latest\bin;C:\Users\masterpowers\AppData\Local\Microsoft\WindowsApps;C:\Users\masterpowers\AppData\Local\Programs\Microsoft VS Code\bin;C:\Users\masterpowers\.cargo\bin;C:\Users\masterpowers\scoop\apps\postgresql\current\bin;C:\Users\masterpowers\scoop\shims;C:\Program Files\VSCodium\bin;C:\Program Files\Microsoft VS Code\bin;;C:\WINDOWS\system32;C:\WINDOWS;C:\WINDOWS\System32\Wbem;C:\WINDOWS\System32\WindowsPowerShell\v1.0\;C:\WINDOWS\System32\OpenSSH\;C:\Program Files\Rust stable MSVC 1.54\bin;C:\Program Files\PowerShell\7\
