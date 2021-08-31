import 'package:get/get.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class WizardController extends GetxController {
  final RxInt _currentStep = 0.obs;
  final RxBool _complete = false.obs;
  final WizardService wiz = Get.find<WizardService>();
  final RxBool _hugoInstalled = false.obs;
  final RxBool _webiInstalled = false.obs;
  final RxBool _brewInstalled = false.obs;
  final RxBool _nodeInstalled = false.obs;
  final RxBool _netlifyInstalled = false.obs;
  final RxBool _netlifyLogged = false.obs;

  @override
  void onInit() {
    initialState();
    // initWebi();
    // initBrew();
    // initHugo();
    // initNode();
    // initNetlify();
    // initAuth();
    super.onInit();
  }

  bool get netlifyLogged {
    return _netlifyLogged.value;
  }

  set netlifyLogged(bool installed) {
    _netlifyLogged.value = installed;
  }

  bool get netlifyInstalled {
    return _netlifyInstalled.value;
  }

  set netlifyInstalled(bool installed) {
    _netlifyInstalled.value = installed;
  }

  bool get nodeInstalled {
    return _nodeInstalled.value;
  }

  set nodeInstalled(bool installed) {
    _nodeInstalled.value = installed;
  }

  bool get hugoInstalled {
    return _hugoInstalled.value;
  }

  set hugoInstalled(bool installed) {
    _hugoInstalled.value = installed;
  }

  bool get brewInstalled {
    return _brewInstalled.value;
  }

  set brewInstalled(bool installed) {
    _brewInstalled.value = installed;
  }

  bool get webiInstalled {
    return _webiInstalled.value;
  }

  set webiInstalled(bool installed) {
    _webiInstalled.value = installed;
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
