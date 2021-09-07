import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';

import '../controllers/site_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteController>(
      () => SiteController(),
    );
    Get.lazyPut<ProjectController>(
      () => ProjectController(),
    );
  }
}
