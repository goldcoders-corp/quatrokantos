import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/services/netlify_auth_service.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class NetlifyAuthMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final NetlifyAuthService netlify = Get.find<NetlifyAuthService>();
    final WizardService wizard = Get.find<WizardService>();
    final WizardController stepper = Get.find<WizardController>();
    if (netlify.isLogged == false) {
      // when logged out
      // force wizard completed false
      // to avoid infinite looop
      wizard.completed = false;
      stepper.netlifyLogged = false;
      // this is a complication but can be fixed with
      // not using /wizard , and using /login or other route
      // for now its better not to use this middleware
      return const RouteSettings(name: '/wizard');
    } else {
      return null;
    }
  }
}
