import 'dart:io';

import 'package:process_run/shell.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class PackageManager {
  static String get() {
    if (Platform.isMacOS) {
      return 'brew';
    } else if (Platform.isWindows) {
      return 'scoop';
    } else {
      return linuxPkgManager();
    }
  }

  static String linuxPkgManager() {
    final path = PathEnv.get();
    final env = <String, String>{'PATH': path};
    return whichSync('pacman', environment: env) ??
        whichSync('yum', environment: env) ??
        whichSync('dnf', environment: env) ??
        whichSync('zypper', environment: env) ??
        'apt-get';
  }
}
