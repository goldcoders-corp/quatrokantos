import 'package:get/get.dart';

import '../controllers/sites_controller.dart';

class SitesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SitesController>(
      () => SitesController(),
    );
  }
}
