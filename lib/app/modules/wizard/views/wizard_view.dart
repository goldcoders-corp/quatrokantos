import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/wizard_controller.dart';

class WizardView extends GetView<WizardController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('WizardView'),
        centerTitle: true,
      ),
      body: Center(
        child: Text(
          'WizardView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
