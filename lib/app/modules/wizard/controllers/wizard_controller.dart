import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/constants/wizard_contants.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class WizardController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  final RxInt _currentStep = 0.obs;
  final RxBool _complete = false.obs;
  final WizardService wiz = Get.find<WizardService>();
  final RxBool _hugoInstalled = false.obs;
  final RxBool _webiInstalled = false.obs;
  final RxBool _pkgInstalled = false.obs;
  final RxBool _nodeInstalled = false.obs;
  final RxBool _netlifyInstalled = false.obs;
  final RxBool _netlifyLogged = false.obs;

  @override
  void onInit() {
    initialState();
    initWebi();
    initPkg();
    initHugo();
    initNode();
    initNetlify();
    initNetlifyAuth();
    super.onInit();
  }

  void initNetlifyAuth() {
    final bool? netlify = _getStorage.read(NETLIFY_LOGGED);
    if (netlify == null) {
      netlifyLogged = false;
    } else {
      netlifyLogged = netlify;
    }
  }

  void initNetlify() {
    final bool? netlify = _getStorage.read(NETLIFY_INSTALLED);
    if (netlify == null) {
      netlifyInstalled = false;
    } else {
      netlifyInstalled = netlify;
    }
  }

  void initNode() {
    final bool? node = _getStorage.read(NODE_INSTALLED);
    if (node == null) {
      nodeInstalled = false;
    } else {
      nodeInstalled = node;
    }
  }

  void initHugo() {
    final bool? hugo = _getStorage.read(HUGO_INSTALLED);
    if (hugo == null) {
      hugoInstalled = false;
    } else {
      hugoInstalled = hugo;
    }
  }

  void initWebi() {
    final bool? webi = _getStorage.read(WEBI_INSTALLED);
    if (webi == null) {
      webiInstalled = false;
    } else {
      webiInstalled = webi;
    }
  }

  void initPkg() {
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
    _netlifyLogged.value = _getStorage.read(NETLIFY_LOGGED) as bool;
  }

  bool get netlifyInstalled {
    return _netlifyInstalled.value;
  }

  set netlifyInstalled(bool installed) {
    _getStorage.write(NETLIFY_INSTALLED, val);
    _netlifyInstalled.value = _getStorage.read(NETLIFY_INSTALLED) as bool;
  }

  bool get nodeInstalled {
    return _nodeInstalled.value;
  }

  set nodeInstalled(bool installed) {
    _getStorage.write(NODE_INSTALLED, val);
    _nodeInstalled.value = _getStorage.read(NODE_INSTALLED) as bool;
  }

  bool get hugoInstalled {
    return _hugoInstalled.value;
  }

  set hugoInstalled(bool installed) {
    _getStorage.write(HUGO_INSTALLED, val);
    _hugoInstalled.value = _getStorage.read(HUGO_INSTALLED) as bool;
  }

  bool get pkgInstalled {
    return _pkgInstalled.value;
  }

  set pkgInstalled(bool installed) {
    _getStorage.write(PKG_INSTALLED, val);
    _pkgInstalled.value = _getStorage.read(PKG_INSTALLED) as bool;
  }

  bool get webiInstalled {
    return _webiInstalled.value;
  }

  set webiInstalled(bool installed) {
    _getStorage.write(WEBI_INSTALLED, val);
    _webiInstalled.value = _getStorage.read(WEBI_INSTALLED) as bool;
  }

  void cancel() {
    if (currentStep == 0) {
      return;
    } else {
      if (currentStep > 0) {
        currentStep--;
      }
    }
  }

  // ignore: use_setters_to_change_properties
  void tap(int step) {
    currentStep = step;
  }

  void next() {
    // if (currentStep == 0) {
    // check if we have webi
    // check if we have brew
    // if yes we invoke next
    // } else if (currentStep == 1) {
    // check if we have hugo
    // check if we have node
    // } else if (currentStep == 2) {
    // check if we have netlify
    // check if we get auth from netlify status
    // }
    // here when complete true
    // then we need to set completed on wizard service
    // and invoke Get.offNamed('/home');
    currentStep + 1 < 3 ? currentStep++ : complete = true;
    if (complete == true) {
      wiz.completed = true;
      Get.snackbar(
        'Congratulations',
        'Your All Ready To Start Creating Sites',
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
    }
  }

  void initialState() {
    _currentStep.value = currentStep;
  }

  int get currentStep {
    return _currentStep.value;
  }

  set currentStep(int step) {
    _currentStep.value = step;
  }

  bool get complete {
    return _complete.value;
  }

  set complete(bool done) {
    _complete.value = done;
  }
}