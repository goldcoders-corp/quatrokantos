import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menubar/menubar.dart' as menubar;

void setGlobalMenu() {
  menubar.setApplicationMenu(<menubar.Submenu>[
    menubar.Submenu(label: 'Run', children: <menubar.AbstractMenuItem>[
      menubar.MenuItem(
        label: 'Install',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Install Dependencies',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Start CMS',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Starting Local Server',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Stop CMS',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Killing... process of Isolate',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Build Site',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Optimizing Site for Production',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Deploy Site',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Make Sure You Build Site Before Running Deploy!',
            ),
          );
        },
      ),
    ]),
    menubar.Submenu(label: 'About Us', children: <menubar.AbstractMenuItem>[
      menubar.MenuItem(
        label: 'Facebook Fanpage',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Creating a New Site',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Company Website',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Creating a New Site',
            ),
          );
        },
      ),
    ]),
  ]);
}
