import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/sites_controller.dart';

class SitesView extends GetView<SitesController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SitesView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'SitesView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
