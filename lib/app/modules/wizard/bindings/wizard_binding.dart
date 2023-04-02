// ignore_for_file: unnecessary_lambdas

import 'package:get/get.dart';
import 'package:quatrokantos/controllers/command_controller.dart';

import '../controllers/wizard_controller.dart';

class WizardBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut<WizardController>(
        () => WizardController(),
      )
      ..lazyPut<CommandController>(
        () => CommandController(),
      );
  }
}
