import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:menubar/menubar.dart' as menubar;

void setGlobalMenu() {
  menubar.setApplicationMenu(<menubar.Submenu>[
    menubar.Submenu(
        label: 'Getting Started',
        children: <menubar.AbstractMenuItem>[
          menubar.MenuItem(
            label: 'Get App Requiments',
            onClicked: () {
              Get.defaultDialog(
                title: 'Alert',
                content: const Text(
                  'Downloading all Necessary Dependencies',
                ),
              );
            },
          ),
          menubar.MenuItem(
            label: 'Login Netlify Account',
            onClicked: () {
              Get.defaultDialog(
                title: 'Alert',
                content: const Text(
                  'Login to Netlify Account',
                ),
              );
            },
          ),
          menubar.MenuItem(
            label: 'Download Themes',
            onClicked: () {
              Get.defaultDialog(
                title: 'Alert',
                content: const Text(
                  'Show Download Theme Page',
                ),
              );
            },
          ),
          menubar.MenuItem(
            label: 'Create New Site',
            onClicked: () {
              Get.defaultDialog(
                title: 'Alert',
                content: const Text(
                  'Creating New Sites',
                ),
              );
            },
          ),
        ]),
    menubar.Submenu(label: 'Scripts', children: <menubar.AbstractMenuItem>[
      menubar.MenuItem(
        label: 'Start Server',
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
        label: 'Stop Server',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Stopping Local Server',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Push To Staging Site',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Pushing to Staging Site',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Push to Production Site',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Pushing to Live Site',
            ),
          );
        },
      ),
    ]),
    menubar.Submenu(label: 'Go', children: <menubar.AbstractMenuItem>[
      menubar.MenuItem(
        label: 'Content Management System',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Launching CMS',
            ),
          );
        },
      ),
      menubar.MenuItem(
        label: 'Local Website',
        onClicked: () {
          Get.defaultDialog(
            title: 'Alert',
            content: const Text(
              'Launching Local Site',
            ),
          );
        },
      ),
    ]),
  ]);
}
