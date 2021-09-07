import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/views/dashboard_screen.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/responsive.dart';
import 'package:quatrokantos/widgets/run_btn.dart';
import 'package:quatrokantos/widgets/side_menu.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

import '../controllers/site_list_controller.dart';

class HomeView extends GetView<SiteListController> {
  @override
  Widget build(BuildContext context) {
    final CommandController ctrl = Get.put(CommandController());
    return Scaffold(
      appBar: TopBar(title: 'Site Manager'),
      drawer: const SideMenu(),
      body: Ink(
        padding: const EdgeInsets.all(defaultPadding),
        color: appColors[BG],
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // We want this side menu only for large screen
            if (Responsive.isDesktop(context))
              const Expanded(
                // default flex = 1
                // and it takes 1/6 part of the screen
                child: SideMenu(),
              ),
            Expanded(
              // It takes 5/6 part of the screen
              flex: 4,
              child: DashboardScreen(),
            ),
          ],
        ),
      ),
      floatingActionButton: Obx(
        () => (ctrl.isLoading == false)
            ? RunBtn(
                title: 'Load Sites',
                icon: Icons.refresh,
                onTap: () async {
                  controller.fetchSites();
                },
              )
            : SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  color: Colors.pink.shade200,
                ),
              ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniCenterFloat,
    );
  }
}
