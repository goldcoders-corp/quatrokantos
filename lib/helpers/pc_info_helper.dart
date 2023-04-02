import 'package:system_info/system_info.dart';

class PC {
  /// #### Helper Static Getter to Get Current User
  /// #### returns: `username`
  static String get user {
    return SysInfo.userName;
  }

  /// #### Helper Static Getter to Get System Architecture
  /// #### return either of the ff: `[X86_64,i686]`
  static String get architecture {
    return SysInfo.kernelArchitecture;
  }

  /// #### Helper Static Getter to Get Kernel Bytes
  /// #### > return either of the ff: `[32 , 64]`
  static int get bit {
    return SysInfo.kernelBitness;
  }

  /// #### Helper Static Getter to Get Sytem Kernel Name
  /// #### return either of the ff: [Darwin,Linux, Windows10]
  static String get kernel {
    return SysInfo.kernelName;
  }

  /// #### Helper Static Getter to Get Operating System
  /// #### return either of the ff: [macOS , windows , Ubuntu]
  static String get os {
    return SysInfo.operatingSystemName;
  }

  /// #### Helper Static Getter to Get OS Version
  /// #### returns `14.04` i.e. for Ubuntu
  /// #### Useful when targetting Version Greater than the One we Will Support
  static String get osVersion {
    return SysInfo.operatingSystemVersion;
  }

  /// #### Helper Static Getter to Get Chip Name
  /// #### returns i.e.: `Apple M1`
  /// Useful For Targetting in MacOS Different Chipset
  static String get chip {
    late String name;

    final processors = SysInfo.processors;

    for (final processor in processors) {
      name = processor.name;
      break;
    }
    return name;
  }

  /// #### Helper Static Getter to Get User Directory
  /// #### returns i.e.: `/Users/username`
  /// Useful For setting Up Absolute Path
  static String get userDirectory {
    return SysInfo.userDirectory;
  }
}
