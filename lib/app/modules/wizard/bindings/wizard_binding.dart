import 'package:get/get.dart';
import 'package:quatrokantos/controllers/command_controller.dart';

import '../controllers/wizard_controller.dart';

class WizardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<WizardController>(
      () => WizardController(),
    );
    Get.lazyPut<CommandController>(
      () => CommandController(),
    );
  }
}
