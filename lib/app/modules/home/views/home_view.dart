import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/views/dashboard_screen.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/responsive.dart';
import 'package:quatrokantos/widgets/side_menu.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

import '../controllers/site_list_controller.dart';

class HomeView extends GetView<SiteListController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Thriftshop Desktop Site Manager'),
      drawer: const SideMenu(),
      body: const DashBoardBody(),
    );
  }
}

enum MenuSelection {
  about,
  // showMessage,
}

class DashBoardBody extends StatefulWidget {
  const DashBoardBody({super.key});

  @override
  State<DashBoardBody> createState() => _DashBoardBodyState();
}

class _DashBoardBodyState extends State<DashBoardBody> {
  // ignore: unused_element
  void _handleMenuSelection(MenuSelection value) {
    switch (value) {
      case MenuSelection.about:
        showAboutDialog(
          context: context,
          applicationName: 'Thriftshop CMS',
          applicationVersion: 'V1.0.0',
        );
        break;
      // ignore: no_default_cases
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Ink(
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
          const Expanded(
            // It takes 5/6 part of the screen
            flex: 4,
            child: DashboardScreen(),
          ),
        ],
      ),
    );
  }
}
