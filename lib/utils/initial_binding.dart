import 'package:get/get.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WizardService());
  }
}
