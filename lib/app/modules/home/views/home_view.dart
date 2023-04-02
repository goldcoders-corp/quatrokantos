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
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Thriftshop Desktop Site Manager'),
      drawer: const SideMenu(),
      body: const MyMenuBarApp(),
    );
  }
}

enum MenuSelection {
  about,
  // showMessage,
}

class MyMenuBarApp extends StatefulWidget {
  const MyMenuBarApp({Key? key}) : super(key: key);

  @override
  State<MyMenuBarApp> createState() => _MyMenuBarAppState();
}

class _MyMenuBarAppState extends State<MyMenuBarApp> {
  void _handleMenuSelection(MenuSelection value) {
    switch (value) {
      case MenuSelection.about:
        showAboutDialog(
          context: context,
          applicationName: 'Thriftshop CMS',
          applicationVersion: 'V1.0.0',
        );
        break;
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    ////////////////////////////////////
    // THIS SAMPLE ONLY WORKS ON MACOS.
    ////////////////////////////////////

    // This builds a menu hierarchy that looks like this:
    // Flutter API Sample
    //  ├ About
    //  ├ ────────  (group divider)
    //  ├ Hide/Show Message
    //  ├ Messages
    //  │  ├ I am not throwing away my shot.
    //  │  └ There's a million things I haven't done, but just you wait.
    //  └ Quit
    return PlatformMenuBar(
      menus: const <PlatformMenuItem>[],
      child: Ink(
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
      ),
    );
  }
}
