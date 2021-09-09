import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/side_menu.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

class ProjectView extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: controller.local_name,
      ),
      drawer: const SideMenu(),
      body: Ink(
        padding: const EdgeInsets.all(defaultPadding),
        color: appColors[BG],
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            TextButton(
                onPressed: () {
                  Get.snackbar('Downloading Theme', 'Thriftshop Theme');
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
