import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class WizardMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final wizard = Get.find<WizardService>();
    if (wizard.completed == false) {
      return const RouteSettings(name: '/wizard');
    } else {
      return null;
    }
  }
}
