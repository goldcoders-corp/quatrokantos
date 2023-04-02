// ignore_for_file: unnecessary_lambdas

import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/services/netlify_auth_service.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get
      ..lazyPut(() => WizardService())
      ..lazyPut(() => CommandController())
      ..lazyPut(() => WizardController())
      ..lazyPut(() => NetlifyAuthService());
  }
}
