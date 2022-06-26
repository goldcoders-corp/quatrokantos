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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(title: 'Thriftshop Desktop Site Manager'),
      drawer: const SideMenu(),
      body: MyMenuBarApp(),
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
  // String _message = 'Hello';
  bool _showMessage = false;

  void _handleMenuSelection(MenuSelection value) {
    switch (value) {
      case MenuSelection.about:
        showAboutDialog(
          context: context,
          applicationName: 'Thriftshop CMS',
          applicationVersion: 'V1.0.0',
        );
        break;
      // case MenuSelection.showMessage:
      //   setState(() {
      //     _showMessage = !_showMessage;
      //   });
      //   break;
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
      menus: <MenuItem>[
        PlatformMenu(
          label: 'Flutter API Sample',
          menus: <MenuItem>[
            PlatformMenuItemGroup(
              members: <MenuItem>[
                PlatformMenuItem(
                  label: 'About',
                  onSelected: () {
                    _handleMenuSelection(MenuSelection.about);
                  },
                )
              ],
            ),
            // PlatformMenuItemGroup(
            //   members: <MenuItem>[
            //     PlatformMenuItem(
            //       onSelected: () {
            //         _handleMenuSelection(MenuSelection.showMessage);
            //       },
            //       shortcut: const CharacterActivator('m'),
            //       label: _showMessage ? 'Hide Message' : 'Show Message',
            //     ),
            //     PlatformMenu(
            //       label: 'Messages',
            //       menus: <MenuItem>[
            //         PlatformMenuItem(
            //           label: 'I am not throwing away my shot.',
            //           shortcut: const SingleActivator(LogicalKeyboardKey.digit1,
            //               meta: true),
            //           onSelected: () {
            //             setState(() {
            //               _message = 'I am not throwing away my shot.';
            //             });
            //           },
            //         ),
            //         PlatformMenuItem(
            //           label:
            //               "There's a million things I haven't done, but just you wait.",
            //           shortcut: const SingleActivator(LogicalKeyboardKey.digit2,
            //               meta: true),
            //           onSelected: () {
            //             setState(() {
            //               _message =
            //                   "There's a million things I haven't done, but just you wait.";
            //             });
            //           },
            //         ),
            //       ],
            //     )
            //   ],
            // ),
            if (PlatformProvidedMenuItem.hasMenu(
                PlatformProvidedMenuItemType.quit))
              const PlatformProvidedMenuItem(
                  type: PlatformProvidedMenuItemType.quit),
          ],
        ),
      ],
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
    );
  }
}
