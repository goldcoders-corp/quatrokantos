import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/project_controller.dart';

class ProjectView extends GetView<ProjectController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ProjectView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'ProjectView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
