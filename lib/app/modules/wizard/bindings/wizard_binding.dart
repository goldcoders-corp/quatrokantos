import 'package:get/get.dart';

import '../controllers/wizard_controller.dart';

class WizardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WizardController>(
      () => WizardController(),
    );
  }
}
