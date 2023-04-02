// ignore_for_file: depend_on_referenced_packages, avoid_slow_async_io, inference_failure_on_function_invocation, lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/constants/wizard_contants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class WizardController extends GetxController {
  final GetStorage _getStorage = GetStorage();
  final WizardService wiz = Get.find<WizardService>();
  final CommandController cmd = Get.find<CommandController>();

  final RxInt _currentStep = 0.obs;
  final RxBool _complete = false.obs;
  final RxBool _hugoInstalled = false.obs;
  final RxBool _webiInstalled = false.obs;
  final RxBool _pkgInstalled = false.obs;
  final RxBool _nodeInstalled = false.obs;
  final RxBool _netlifyInstalled = false.obs;
  final RxBool _netlifyLogged = false.obs;
  final RxBool _themeInstalled = false.obs;
  final RxBool _yarnInstalled = false.obs;

  @override
  void onInit() {
    fetchLocalData();
    initStep();
    super.onInit();
  }

  void fetchLocalData() {
    // initWebi();
    webiInstalled = false;
    // initPkg();
    pkgInstalled = false;
    // initHugo();
    hugoInstalled = false;
    // initNode();
    nodeInstalled = false;
    // initYarn();
    yarnInstalled = false;
    // initNetlify();
    netlifyInstalled = false;
    // checkIfThemeInstalled();
    themeInstalled = false;
    // initNetlifyAuth();
    netlifyLogged = false;
  }

  bool get themeInstalled => _themeInstalled.value;
  set themeInstalled(bool val) => _themeInstalled.value = val;

  bool get yarnInstalled => _yarnInstalled.value;

  set yarnInstalled(bool val) {
    _getStorage.write(YARN_INSTALLED, val);
    _yarnInstalled.value = val;
  }

  int get currentStep => _currentStep.value;
  set currentStep(int val) => _currentStep.value = val;

  Future<void> checkIfThemeInstalled() async {
    final zipName = dotenv.env['DEFAULT_SITE_THEME']!;
    final cmZip = p.join(
      PathHelper.getCMSDIR,
      '$zipName.zip',
    );

    final themeZip = p.join(
      PathHelper.getThemeDir,
      '$zipName.zip',
    );

    final cmsDownloaded = await File(cmZip).exists();
    final themeDownloaded = await File(themeZip).exists();

    (cmsDownloaded && themeDownloaded)
        ? themeInstalled = true
        : themeInstalled = false;
  }

  void initNetlifyAuth() {
    // ignore: omit_local_variable_types
    final bool? netlify = _getStorage.read(NETLIFY_LOGGED);
    if (netlify == null) {
      netlifyLogged = false;
    } else {
      netlifyLogged = netlify;
    }
  }

  void initNetlify() {
    // ignore: omit_local_variable_types
    final bool? netlify = _getStorage.read(NETLIFY_INSTALLED);
    if (netlify == null) {
      netlifyInstalled = false;
    } else {
      netlifyInstalled = netlify;
    }
  }

  void initNode() {
    // ignore: omit_local_variable_types
    final bool? node = _getStorage.read(NODE_INSTALLED);
    if (node == null) {
      nodeInstalled = false;
    } else {
      nodeInstalled = node;
    }
  }

  void initHugo() {
    // ignore: omit_local_variable_types
    final bool? hugo = _getStorage.read(HUGO_INSTALLED);
    if (hugo == null) {
      hugoInstalled = false;
    } else {
      hugoInstalled = hugo;
    }
  }

  void initWebi() {
    // ignore: omit_local_variable_types
    final bool? webi = _getStorage.read(WEBI_INSTALLED);
    if (webi == null) {
      webiInstalled = false;
    } else {
      webiInstalled = webi;
    }
  }

  void initPkg() {
    // ignore: omit_local_variable_types
    final bool? pkg = _getStorage.read(PKG_INSTALLED);
    if (pkg == null) {
      pkgInstalled = false;
    } else {
      pkgInstalled = pkg;
    }
  }

  bool get netlifyLogged {
    return _netlifyLogged.value;
  }

  set netlifyLogged(bool val) {
    _getStorage.write(NETLIFY_LOGGED, val);
    _netlifyLogged.value = val;
  }

  bool get netlifyInstalled {
    return _netlifyInstalled.value;
  }

  set netlifyInstalled(bool val) {
    _getStorage.write(NETLIFY_INSTALLED, val);
    _netlifyInstalled.value = val;
  }

  bool get nodeInstalled {
    return _nodeInstalled.value;
  }

  set nodeInstalled(bool val) {
    _getStorage.write(NODE_INSTALLED, val);
    _nodeInstalled.value = val;
  }

  bool get hugoInstalled {
    return _hugoInstalled.value;
  }

  set hugoInstalled(bool val) {
    _getStorage.write(HUGO_INSTALLED, val);
    _hugoInstalled.value = val;
  }

  bool get pkgInstalled {
    return _pkgInstalled.value;
  }

  set pkgInstalled(bool val) {
    _getStorage.write(PKG_INSTALLED, val);
    _pkgInstalled.value = val;
  }

  bool get webiInstalled {
    return _webiInstalled.value;
  }

  set webiInstalled(bool val) {
    _getStorage.write(WEBI_INSTALLED, val);
    _webiInstalled.value = val;
  }

  void cancel() {
    if (cmd.isLoading == false) {
      if (currentStep == 0) {
        return;
      } else {
        if (currentStep > 0) {
          currentStep--;
        }
      }
    }
  }

  // ignore: use_setters_to_change_properties
  void tap(int step) {
    if (cmd.isLoading == false) {
      currentStep = step;
    }
  }

  void next() {
    if (currentStep == 0) {
      if (webiInstalled) {
        currentStep++;
      }
    } else if (currentStep == 1) {
      if (pkgInstalled) {
        currentStep++;
      }
    } else if (currentStep == 2) {
      if (hugoInstalled) {
        currentStep++;
      }
    } else if (currentStep == 3) {
      if (nodeInstalled) {
        currentStep++;
      }
    } else if (currentStep == 4) {
      if (yarnInstalled) {
        currentStep++;
      }
    } else if (currentStep == 5) {
      if (netlifyInstalled) {
        currentStep++;
      }
    } else if (currentStep == 6) {
      if (themeInstalled) {
        currentStep++;
      }
    } else if (currentStep == 7) {
      if (netlifyLogged) {
        complete = true;
        wiz.completed = true;
        Get.toNamed('/home');
      }
    } else {
      currentStep++;
      if (currentStep >= 7) {
        currentStep = 7;
      }
    }
  }

  void initStep() {
    if (netlifyLogged == false) {
      currentStep = 7;
    }
    if (themeInstalled) {
      currentStep = 6;
    }
    if (netlifyInstalled == false) {
      currentStep = 5;
    }
    if (yarnInstalled == false) {
      currentStep = 4;
    }
    if (nodeInstalled == false) {
      currentStep = 3;
    }
    if (hugoInstalled == false) {
      currentStep = 2;
    }
    if (pkgInstalled == false) {
      currentStep = 1;
    }
    if (webiInstalled == false) {
      currentStep = 0;
    }
  }

  bool get complete {
    return _complete.value;
  }

  set complete(bool done) {
    _complete.value = done;
  }

  void initYarn() {
    // ignore: omit_local_variable_types
    final bool? node = _getStorage.read(YARN_INSTALLED);
    if (node == null) {
      yarnInstalled = false;
    } else {
      yarnInstalled = node;
    }
  }
}
