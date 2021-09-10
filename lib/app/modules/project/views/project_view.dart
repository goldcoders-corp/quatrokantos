import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/cms/cms_ctrl.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/helpers/folder_launcher.dart';
import 'package:quatrokantos/helpers/url_launcher_helper.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/side_menu.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

class ProjectView extends GetView<ProjectController> {
  final CmsController cmsCtrl = Get.put(CmsController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: controller.local_name,
      ),
      drawer: const SideMenu(),
      body: Ink(
        padding: const EdgeInsets.all(defaultPadding),
        color: appColors[BG],
        child: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Obx(() {
                  if (controller.themeInstalled == false) {
                    return Card(
                        child: ListTile(
                      title: DropdownButton<String>(
                        value: (cmsCtrl.currentTheme == '')
                            ? null
                            : cmsCtrl.currentTheme,
                        isExpanded: true,
                        onChanged: (String? newValue) {
                          cmsCtrl.currentTheme = newValue!;
                        },
                        hint: const Text(
                          'Please Pick a Theme To Used',
                        ),
                        items: cmsCtrl.themeNames
                            .map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text('$value theme'),
                          );
                        }).toList(),
                      ),
                      trailing: Obx(() {
                        if (controller.themeInstalled == false &&
                            cmsCtrl.isLoading == false) {
                          return IconButton(
                            onPressed: () async {
                              if (cmsCtrl.getChoosen != null) {
                                await cmsCtrl.download(
                                    controller.local_name, cmsCtrl.getChoosen!);
                                // ignore: always_specify_types
                                Future.delayed(const Duration(seconds: 1));
                              }
                            },
                            icon: const Icon(Icons.download),
                          );
                        } else {
                          return CircularProgressIndicator(
                            color: Colors.red.shade200,
                            backgroundColor: Colors.white54,
                          );
                        }
                      }),
                    ));
                  } else {
                    return Card(
                      color: Colors.white30,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.download_done),
                            title: const Text('Site Theme Installed At:'),
                            subtitle: Text(controller.path),
                            trailing: IconButton(
                              onPressed: () {
                                final Folder folder =
                                    Folder(name: controller.path);
                                folder.open();
                              },
                              icon: const Icon(Icons.folder),
                            ),
                          ),
                        ],
                      ),
                    );
                  }
                }),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.warning),
                        title: const Text('Install Site Dependecies'),
                        subtitle: const Text(
                            // ignore: lines_longer_than_80_chars
                            'Before We Can Run Locally We Need to Install Site Dependencies'),
                        trailing: IconButton(
                          onPressed: () {
                            // NPM RUN INSTALL
                            final Folder folder = Folder(name: controller.path);
                            folder.open();
                          },
                          icon: const Icon(Icons.file_download),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.dynamic_form),
                        title: const Text('Run CMS'),
                        subtitle: Column(
                          children: <Widget>[
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                    'Open Local Site at http://localhost:1313'),
                                IconButton(
                                  onPressed: () async {
                                    const UrlLauncher openURL = UrlLauncher(
                                        url: 'http://localhost:1313');
                                    await openURL();
                                  },
                                  icon: const Icon(Icons.travel_explore),
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: <Widget>[
                                const Text(
                                    'Open Content Management System at http://localhost:1234'),
                                IconButton(
                                  onPressed: () async {
                                    const UrlLauncher openURL = UrlLauncher(
                                        url: 'http://localhost:1234');
                                    await openURL();
                                  },
                                  icon: const Icon(Icons.travel_explore),
                                ),
                              ],
                            ),
                          ],
                        ),
                        trailing: IconButton(
                          onPressed: () {
                            // NPM RUN INSTALL
                            final Folder folder = Folder(name: controller.path);
                            folder.open();
                          },
                          icon: const Icon(Icons.play_circle_filled),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.build),
                        title: const Text('Build Site'),
                        subtitle: const Text(
                            // ignore: lines_longer_than_80_chars
                            'Build Site For Production Prior , Deploying it to Live Site'),
                        trailing: IconButton(
                          onPressed: () {
                            // NPM RUN INSTALL
                            final Folder folder = Folder(name: controller.path);
                            folder.open();
                          },
                          icon: const Icon(Icons.view_in_ar),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.cloud),
                        title: const Text('Deploy Site'),
                        subtitle: const Text(
                            'Build Your Site For Production and Deploy'),
                        trailing: IconButton(
                          onPressed: () {
                            // NPM RUN INSTALL
                            final Folder folder = Folder(name: controller.path);
                            folder.open();
                          },
                          icon: const Icon(Icons.cloud_upload),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Card(
                  color: Colors.white30,
                  child: Column(
                    children: <Widget>[
                      ListTile(
                        leading: const Icon(Icons.web),
                        title: const Text('Visit Live Site'),
                        subtitle:
                            const Text('Check Your Website in Production'),
                        trailing: IconButton(
                          onPressed: () async {
                            if (controller.default_domain != '') {
                              final UrlLauncher openURL = UrlLauncher(
                                  url: 'https://${controller.default_domain}');
                              await openURL();
                            } else {
                              final UrlLauncher openURL = UrlLauncher(
                                  url: 'https://${controller.custom_domain}');
                              await openURL();
                            }
                          },
                          icon: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
