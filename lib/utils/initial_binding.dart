import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/services/netlify_auth_service.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WizardService());
    Get.lazyPut(() => CommandController());
    Get.lazyPut(() => WizardController());
    Get.lazyPut(() => NetlifyAuthService());
  }
}
