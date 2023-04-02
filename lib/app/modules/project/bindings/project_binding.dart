// ignore_for_file: unnecessary_lambdas

import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';

class ProjectBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProjectController>(
      () => ProjectController(),
    );
  }
}
