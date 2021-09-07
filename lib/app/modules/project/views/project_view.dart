import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

import '../controllers/site_controller.dart';

class ProjectView extends GetView<SiteController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Create New Site',
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            Obx(() {
              return Text(
                'Site ID: ${controller.id}',
                style: const TextStyle(fontSize: 20),
              );
            }),
            TextButton(
                onPressed: () {
                  controller.id = '1000';
                },
                child: const Text('Update')),
          ],
        ),
      ),
    );
  }
}
