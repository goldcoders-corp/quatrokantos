import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

class ProjectView extends GetView<ProjectController> {
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
