// ignore_for_file: depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/cms/cms_ctrl.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/helpers/env_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/folder_launcher.dart';
import 'package:quatrokantos/helpers/kill_all.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';
import 'package:quatrokantos/helpers/url_launcher_helper.dart';
import 'package:quatrokantos/helpers/writter_helper.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/npm/yarn.dart';
import 'package:quatrokantos/widgets/side_menu.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

class ProjectView extends GetView<ProjectController> {
  const ProjectView({super.key});
  @override
  Widget build(BuildContext context) {
    final cmsCtrl = Get.put(CmsController());
    return Scaffold(
      appBar: TopBar(
        title: controller.local_name,
      ),
      drawer: const SideMenu(),
      body: Ink(
        padding: const EdgeInsets.all(defaultPadding),
        color: appColors[BG],
        child: SizedBox.expand(
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
                                    controller.local_name,
                                    cmsCtrl.getChoosen!,
                                  );
                                  // ignore: always_specify_types
                                  await EnvHelper.copyOrCreateDotEnv(
                                    controller.path,
                                  );
                                  await Future<void>.delayed(
                                    const Duration(seconds: 1),
                                  );
                                }
                              },
                              icon: const Icon(Icons.download),
                            );
                          } else {
                            return CircularProgressIndicator(
                              color: Colors.pink.shade200,
                              backgroundColor: Colors.white54,
                            );
                          }
                        }),
                      ),
                    );
                  } else {
                    return Card(
                      color: Colors.white30,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: Icon(
                              Icons.download_done,
                              color: Colors.teal.shade200,
                            ),
                            title: const Text('Site Theme Installed At:'),
                            subtitle: Text(controller.path),
                            trailing: IconButton(
                              onPressed: () {
                                final folder = Folder(name: controller.path);
                                // ignore: cascade_invocations
                                folder.open();
                              },
                              icon: Icon(
                                Icons.folder,
                                color: Colors.yellow.shade200,
                              ),
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
                Obx(() {
                  return Card(
                    color: Colors.white30,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: (controller.npmInstalled == false)
                              ? Icon(
                                  Icons.warning,
                                  color: Colors.orange.shade200,
                                )
                              : Icon(Icons.check, color: Colors.teal.shade200),
                          title: (controller.npmInstalled == false)
                              ? const Text('Install Site Dependecies')
                              : const Text('Site Dependecies Installed'),
                          subtitle: (controller.npmInstalled == false)
                              ? const Text(
                                  // ignore: lines_longer_than_80_chars
                                  'Before We Can Run Locally We Need to Install Site Dependencies',
                                )
                              : const Text(
                                  // ignore: lines_longer_than_80_chars
                                  'You can Re-Install Dependencies in Case Your Facing Issues',
                                ),
                          trailing: (controller.isIntalling == false)
                              ? IconButton(
                                  onPressed: () async {
                                    await Yarn.install(controller);
                                    await controller.isNodeModulesInstalled(
                                      controller.local_name,
                                    );
                                  },
                                  icon: (controller.npmInstalled == false)
                                      ? const Icon(Icons.file_download)
                                      : Icon(
                                          Icons.published_with_changes,
                                          color: Colors.teal.shade200,
                                        ),
                                )
                              : CircularProgressIndicator(
                                  color: Colors.pink.shade200,
                                  backgroundColor: Colors.white54,
                                ),
                        ),
                      ],
                    ),
                  );
                }),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Card(
                    color: Colors.white30,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          minVerticalPadding: 10,
                          leading: Icon(
                            Icons.dynamic_form,
                            color: Colors.purple.shade200,
                          ),
                          title: (controller.canKillAll == false)
                              ? const Text('Run CMS')
                              : const Text('CMS Running'),
                          subtitle: (controller.canKillAll == true)
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: <Widget>[
                                    const Expanded(child: SizedBox()),
                                    Row(
                                      children: <Widget>[
                                        const Text('View Site Offline'),
                                        IconButton(
                                          onPressed: () async {
                                            const openURL = UrlLauncher(
                                              url: 'http://localhost:1313',
                                            );
                                            await openURL();
                                          },
                                          icon: Icon(
                                            Icons.travel_explore,
                                            color: Colors.indigo.shade200,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Expanded(child: SizedBox()),
                                    Row(
                                      children: <Widget>[
                                        const Text('Launch CMS'),
                                        IconButton(
                                          onPressed: () async {
                                            const openURL = UrlLauncher(
                                              url: 'http://localhost:1234',
                                            );
                                            await openURL();
                                          },
                                          icon: Icon(
                                            Icons.launch,
                                            color: Colors.indigo.shade200,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const Expanded(child: SizedBox())
                                  ],
                                )
                              : Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: const <Widget>[
                                    Text('To Modify Site Content Run CMS'),
                                  ],
                                ),
                          trailing: (controller.canKillAll == false)
                              ? IconButton(
                                  onPressed: () async {
                                    await Yarn.cms(controller);
                                  },
                                  icon: Icon(
                                    Icons.play_arrow,
                                    color: Colors.teal.shade200,
                                  ),
                                )
                              : Stack(
                                  children: <Widget>[
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      top: 0,
                                      left: 0,
                                      child: CircularProgressIndicator(
                                        color: Colors.pink.shade200,
                                        backgroundColor: Colors.white54,
                                      ),
                                    ),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: () async {
                                          final kill = KillAll(
                                            unixCmd: 'node',
                                            winCmd: 'node.exe',
                                          );
                                          await kill();
                                          controller.canKillAll = false;
                                        },
                                        icon: Icon(
                                          Icons.stop,
                                          color: Colors.pink.shade200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Card(
                    color: Colors.white30,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading:
                              Icon(Icons.build, color: Colors.brown.shade700),
                          title: const Text('Ready To Deploy Your Site?'),
                          subtitle: const Text(
                            // ignore: lines_longer_than_80_chars
                            'Build Production Grade Site then Deploy Your Site',
                          ),
                          trailing: (controller.isBuilding == false)
                              ? IconButton(
                                  onPressed: () async {
                                    controller.isBuilding = true;
                                    final kill = KillAll(
                                      unixCmd: 'node',
                                      winCmd: 'node.exe',
                                    );
                                    await kill();
                                    var folder =
                                        dotenv.env['APP_NAME']!.toLowerCase();
                                    // ignore: unnecessary_string_escapes
                                    final text = ReplaceHelper(
                                      text: folder,
                                      regex: r'\s+',
                                    );
                                    folder = text.replace();
                                    const filename = 'npm_debug.txt';
                                    final filePath = p.join(
                                      PC.userDirectory,
                                      '.local',
                                      'share',
                                      '.$folder',
                                      filename,
                                    );
                                    final command = whichSync(
                                      'npm',
                                      environment: (Platform.isWindows)
                                          ? null
                                          : <String, String>{
                                              'PATH': PathEnv.get()
                                            },
                                    );
                                    try {
                                      controller.isBuilding = true;

                                      final process = await Process.start(
                                        command!,
                                        <String>['run', 'prod'],
                                        environment: (Platform.isWindows)
                                            ? null
                                            : <String, String>{
                                                'PATH': PathEnv.get()
                                              },
                                        workingDirectory: controller.path,
                                        runInShell: true,
                                      );

                                      final outputStream = process.stdout
                                          .transform(const Utf8Decoder())
                                          .transform(
                                            const LineSplitter(),
                                          );

                                      await for (final String line
                                          in outputStream) {
                                        await WritterHelper.log(
                                          filePath: filePath,
                                          stacktrace: line,
                                        );
                                      }

                                      final errorStream = process.stderr
                                          .transform(const Utf8Decoder())
                                          .transform(
                                            const LineSplitter(),
                                          );
                                      await for (final String line
                                          in errorStream) {
                                        await WritterHelper.log(
                                          filePath: filePath,
                                          stacktrace: line,
                                        );
                                      }
                                    } catch (e, stacktrace) {
                                      await WritterHelper.log(
                                        filePath: filePath,
                                        stacktrace: stacktrace.toString(),
                                      );
                                    } finally {
                                      controller.isBuilding = false;
                                      Get.snackbar(
                                        'Building Site Done',
                                        // ignore: lines_longer_than_80_chars
                                        'Site Ready to Be Deployed to Live Site',
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                      );
                                      final kill = KillAll(
                                        unixCmd: 'node',
                                        winCmd: 'node.exe',
                                      );
                                      await kill();
                                    }
                                  },
                                  icon: const Icon(
                                    Icons.view_in_ar,
                                    color: Colors.lightBlueAccent,
                                  ),
                                )
                              : Stack(
                                  children: <Widget>[
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      top: 0,
                                      left: 0,
                                      child: CircularProgressIndicator(
                                        color: Colors.lightBlueAccent.shade200,
                                        backgroundColor: Colors.white54,
                                      ),
                                    ),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: () async {
                                          final kill = KillAll(
                                            unixCmd: 'node',
                                            winCmd: 'node.exe',
                                          );
                                          await kill();
                                          controller.isBuilding = false;
                                        },
                                        icon: Icon(
                                          Icons.stop,
                                          color:
                                              Colors.lightBlueAccent.shade200,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Card(
                    color: Colors.white30,
                    child: Column(
                      children: <Widget>[
                        ListTile(
                          leading: Icon(
                            Icons.cloud,
                            color: Colors.blue.shade200,
                          ),
                          title: const Text('Deploy Site'),
                          subtitle:
                              const Text('1 Click and Deploy Your Site Live'),
                          trailing: (controller.isDeploying == false)
                              ? IconButton(
                                  onPressed: () async {
                                    controller.isDeploying = true;
                                    final kill = KillAll(
                                      unixCmd: 'node',
                                      winCmd: 'node.exe',
                                    );
                                    await kill();
                                    var folder =
                                        dotenv.env['APP_NAME']!.toLowerCase();
                                    // ignore: unnecessary_string_escapes
                                    final text = ReplaceHelper(
                                      text: folder,
                                      regex: r'\s+',
                                    );
                                    folder = text.replace();
                                    const filename = 'npm_debug.txt';
                                    final filePath = p.join(
                                      PC.userDirectory,
                                      '.local',
                                      'share',
                                      '.$folder',
                                      filename,
                                    );
                                    final command = whichSync(
                                      'ntl',
                                      environment: (Platform.isWindows)
                                          ? null
                                          : <String, String>{
                                              'PATH': PathEnv.get()
                                            },
                                    );
                                    try {
                                      controller.isDeploying = true;

                                      final process = await Process.start(
                                        command!,
                                        <String>['deploy', '--prod'],
                                        environment: (Platform.isWindows)
                                            ? null
                                            : <String, String>{
                                                'PATH': PathEnv.get()
                                              },
                                        workingDirectory: controller.path,
                                        runInShell: true,
                                      );

                                      final outputStream = process.stdout
                                          .transform(const Utf8Decoder())
                                          .transform(
                                            const LineSplitter(),
                                          );

                                      await for (final String line
                                          in outputStream) {
                                        await WritterHelper.log(
                                          filePath: filePath,
                                          stacktrace: line,
                                        );
                                      }

                                      final errorStream = process.stderr
                                          .transform(const Utf8Decoder())
                                          .transform(
                                            const LineSplitter(),
                                          );
                                      await for (final String line
                                          in errorStream) {
                                        await WritterHelper.log(
                                          filePath: filePath,
                                          stacktrace: line,
                                        );
                                      }
                                    } catch (e, stacktrace) {
                                      await WritterHelper.log(
                                        filePath: filePath,
                                        stacktrace: stacktrace.toString(),
                                      );
                                    } finally {
                                      controller.isDeploying = false;
                                      Get.snackbar(
                                        'Done Executing Deploy To Live Site',
                                        'Check it Out Now on Live Site!',
                                        dismissDirection:
                                            DismissDirection.horizontal,
                                      );
                                      final kill = KillAll(
                                        unixCmd: 'node',
                                        winCmd: 'node.exe',
                                      );
                                      await kill();
                                    }
                                  },
                                  icon: Icon(
                                    Icons.cloud_upload,
                                    color: Colors.lime.shade100,
                                  ),
                                )
                              : Stack(
                                  children: <Widget>[
                                    Positioned(
                                      bottom: 0,
                                      right: 0,
                                      top: 0,
                                      left: 0,
                                      child: CircularProgressIndicator(
                                        color: Colors.lime.shade100,
                                        backgroundColor: Colors.white54,
                                      ),
                                    ),
                                    Positioned(
                                      child: IconButton(
                                        onPressed: () async {
                                          final kill = KillAll(
                                            unixCmd: 'node',
                                            winCmd: 'node.exe',
                                          );
                                          await kill();
                                          controller.isDeploying = false;
                                        },
                                        icon: Icon(
                                          Icons.stop,
                                          color: Colors.lime.shade100,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                        ),
                      ],
                    ),
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
                        leading: Icon(
                          Icons.web,
                          color: Colors.orange.shade200,
                        ),
                        title: const Text('Visit Live Site'),
                        subtitle:
                            const Text('Check Your Website in Production'),
                        trailing: IconButton(
                          onPressed: () async {
                            if (controller.default_domain != '') {
                              final openURL = UrlLauncher(
                                url: 'https://${controller.default_domain}',
                              );
                              await openURL();
                            } else {
                              final openURL = UrlLauncher(
                                url: 'https://${controller.custom_domain}',
                              );
                              await openURL();
                            }
                          },
                          icon:
                              Icon(Icons.search, color: Colors.orange.shade200),
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
