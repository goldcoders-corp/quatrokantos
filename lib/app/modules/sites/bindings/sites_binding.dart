import 'package:get/get.dart';
import 'package:quatrokantos/controllers/command_controller.dart';

import '../controllers/sites_controller.dart';

class SitesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SitesController>(
      () => SitesController(),
    );
    Get.lazyPut<CommandController>(
      () => CommandController(),
    );
  }
}
