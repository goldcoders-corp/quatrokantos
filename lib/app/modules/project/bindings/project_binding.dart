import 'package:get/get.dart';

import '../controllers/site_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteController>(
      () => SiteController(),
    );
  }
}
