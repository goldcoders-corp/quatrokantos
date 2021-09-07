import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

class ProjectView extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: controller.custom_domain,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Get.snackbar('Downloadig Theme', 'Thriftshop Theme');
                },
                child: const Text('Download Theme')),
            TextButton(
                onPressed: () {
                  Get.snackbar('Linking Site', 'Now Linking Site');
                },
                child: const Text('Link Site')),
            TextButton(
                onPressed: () {
                  Get.snackbar('Build Site', 'Building Site');
                },
                child: const Text('Build Site')),
            TextButton(
                onPressed: () {
                  Get.snackbar(
                      'Deploying Site', 'Production Site Being Deployed');
                },
                child: const Text('Deploy Site')),
            TextButton(
                onPressed: () {
                  Get.snackbar('Run Local Server', 'Running Local Server');
                },
                child: const Text('Run CMS')),
            TextButton(
                onPressed: () {
                  Get.snackbar('Opening Site', 'on http://localhost:13131');
                },
                child: const Text('Open Local Site')),
            TextButton(
                onPressed: () {
                  Get.snackbar('Opening CMS', 'on http://localhost:1234');
                },
                child: const Text('Open CMS ')),
          ],
        ),
      ),
    );
  }
}
