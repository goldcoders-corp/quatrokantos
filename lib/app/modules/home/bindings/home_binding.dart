// ignore_for_file: unnecessary_lambdas

import 'package:get/get.dart';

import '../controllers/site_list_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SiteListController>(
      () => SiteListController(),
    );
  }
}
