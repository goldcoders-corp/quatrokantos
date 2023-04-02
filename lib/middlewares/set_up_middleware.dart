import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class SetUpMiddleware extends GetMiddleware {
  @override
  RouteSettings? redirect(String? route) {
    final wizard = Get.find<WizardService>();
    if (wizard.completed == true) {
      return const RouteSettings(name: '/home');
    } else {
      return null;
    }
  }
}
