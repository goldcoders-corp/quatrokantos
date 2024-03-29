// ignore_for_file: inference_failure_on_function_invocation, inference_failure_on_generic_invocation, lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/components/onboarding_card.dart';
import 'package:quatrokantos/app/modules/wizard/views/netlify_login_dialog.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/download_zip.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pkg_manager.dart';
import 'package:quatrokantos/installers/hugo_installer.dart';
import 'package:quatrokantos/installers/netlify_install.dart';
import 'package:quatrokantos/installers/node_installer.dart';
import 'package:quatrokantos/installers/pkg_manager_installer.dart';
import 'package:quatrokantos/installers/webi_installer.dart';
import 'package:quatrokantos/installers/yarn_installer.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/netlify/netlify_login.dart';
import 'package:quatrokantos/widgets/run_btn.dart';
import 'package:quatrokantos/widgets/top_bar.dart';

import '../controllers/wizard_controller.dart';

class WizardView extends GetView<CommandController> {
  const WizardView({super.key});

  @override
  Widget build(BuildContext context) {
    final wctrl = Get.find<WizardController>();
    // final netlifyService = Get.find<NetlifyAuthService>();
    return Scaffold(
      appBar: TopBar(
        title: 'Thriftshop App Wizard Installation',
      ),
      body: Obx(() {
        return Column(
          children: <Widget>[
            Expanded(
              child: Stepper(
                steps: <Step>[
                  Step(
                    title: const Text('Set Up System Requirements'),
                    isActive: wctrl.currentStep >= 0,
                    state: wctrl.currentStep >= 0
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Dev Tools',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          const command = 'webi';

                                          final env = <String, String>{
                                            'PATH': path,
                                          };
                                          final cmdInstalled = whichSync(
                                            command,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );
                                          if (cmdInstalled != null) {
                                            wctrl.webiInstalled = true;
                                            await Get.defaultDialog(
                                              title: 'Step #1 Done:',
                                              middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final webi = WebiInstall();
                                            await webi(
                                              onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  Process.run(
                                                      'powershell', <String>[
                                                    r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
                                                  ]).asStream().listen((
                                                    ProcessResult process,
                                                  ) async {
                                                    final cmdInstalled =
                                                        whichSync(
                                                      command,
                                                      environment:
                                                          (Platform.isWindows)
                                                              ? null
                                                              : env,
                                                    );
                                                    wctrl.webiInstalled = true;
                                                    await Get.defaultDialog(
                                                      title: 'Step #1 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: Get.back,
                                                        child: const Text('OK'),
                                                      ),
                                                    );
                                                  });
                                                }
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.webiInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Set Up Package Managers'),
                    isActive: wctrl.currentStep >= 1,
                    state: wctrl.currentStep >= 1
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install ${PackageManager.get()}',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          final pkgmanager =
                                              PackageManager.get();
                                          final env = <String, String>{
                                            'PATH': path,
                                          };

                                          final cmdInstalled = whichSync(
                                            pkgmanager,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );
                                          if (cmdInstalled != null) {
                                            wctrl.pkgInstalled = true;

                                            await Get.defaultDialog(
                                              title: 'Step #2 Done:',
                                              middleText: '''
${pkgmanager.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final pkgInstaller =
                                                PkgMangerInstall();
                                            await pkgInstaller(
                                              onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  Process.run(
                                                      'powershell', <String>[
                                                    r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
                                                  ]).asStream().listen((
                                                    ProcessResult process,
                                                  ) async {
                                                    final cmdInstalled =
                                                        whichSync(
                                                      pkgmanager,
                                                      environment:
                                                          (Platform.isWindows)
                                                              ? null
                                                              : env,
                                                    );
                                                    wctrl.pkgInstalled = true;
                                                    await Get.defaultDialog(
                                                      title: 'Step #2 Done:',
                                                      middleText: '''
${pkgmanager.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: Get.back,
                                                        child: const Text('OK'),
                                                      ),
                                                    );
                                                  });
                                                }
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.pkgInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Set Up Local Site Server'),
                    isActive: wctrl.currentStep >= 2,
                    state: wctrl.currentStep >= 2
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Hugo',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          const command = 'hugo';

                                          final env = <String, String>{
                                            'PATH': path,
                                          };

                                          final cmdInstalled = whichSync(
                                            command,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );
                                          if (cmdInstalled != null) {
                                            wctrl.hugoInstalled = true;

                                            await Get.defaultDialog(
                                              title: 'Step #3 Done:',
                                              middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final hugoInstaller = HugoInstall();
                                            await hugoInstaller(
                                              onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  Process.run(
                                                      'powershell', <String>[
                                                    r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
                                                  ]).asStream().listen((
                                                    ProcessResult process,
                                                  ) async {
                                                    final cmdInstalled =
                                                        whichSync(
                                                      command,
                                                      environment:
                                                          (Platform.isWindows)
                                                              ? null
                                                              : env,
                                                    );
                                                    wctrl.hugoInstalled = true;
                                                    await Get.defaultDialog(
                                                      title: 'Step #1 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: Get.back,
                                                        child: const Text('OK'),
                                                      ),
                                                    );
                                                  });
                                                }
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.hugoInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Set Up Local Backend Server'),
                    isActive: wctrl.currentStep >= 3,
                    state: wctrl.currentStep >= 3
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Node',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          const command = 'node';

                                          final env = <String, String>{
                                            'PATH': path,
                                          };
                                          final cmdInstalled = whichSync(
                                            command,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );
                                          if (cmdInstalled != null) {
                                            wctrl.nodeInstalled = true;

                                            await Get.defaultDialog(
                                              title: 'Step #4 Done:',
                                              middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final nodeInstaller = NodeInstall();
                                            await nodeInstaller(
                                              onDone: (
                                                bool installed,
                                              ) async {
                                                if (installed == true) {
                                                  Process.run(
                                                      'powershell', <String>[
                                                    r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
                                                  ]).asStream().listen((
                                                    ProcessResult process,
                                                  ) async {
                                                    final cmdInstalled =
                                                        whichSync(
                                                      command,
                                                      environment:
                                                          (Platform.isWindows)
                                                              ? null
                                                              : env,
                                                    );

                                                    await Get.defaultDialog(
                                                      title: 'Step #4 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: Get.back,
                                                        child: const Text('OK'),
                                                      ),
                                                    );
                                                  });
                                                  wctrl.nodeInstalled = true;
                                                }
                                                //
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.nodeInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Set Site Package Manager'),
                    isActive: wctrl.currentStep >= 4,
                    state: wctrl.currentStep >= 4
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Yarn',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          const command = 'yarn';

                                          final env = <String, String>{
                                            'PATH': path,
                                          };
                                          final cmdInstalled = whichSync(
                                            command,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );

                                          if (cmdInstalled != null) {
                                            wctrl.yarnInstalled = true;

                                            await Get.defaultDialog(
                                              title: 'Step #5 Done:',
                                              middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final yarn = YarnInstaller();
                                            await yarn(
                                              onDone: (bool yarn) {
                                                wctrl.yarnInstalled = true;
                                                Process.run(
                                                    'powershell', <String>[
                                                  r'''
$env:Path = [System.Environment]::GetEnvironmentVariable("Path","User")'''
                                                ]).asStream().listen((
                                                  ProcessResult process,
                                                ) async {
                                                  final cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment:
                                                        (Platform.isWindows)
                                                            ? null
                                                            : env,
                                                  );
                                                  wctrl.yarnInstalled = true;
                                                  await Get.defaultDialog(
                                                    title: 'Step #5 Done:',
                                                    middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                        .trim(),
                                                    confirm: TextButton(
                                                      onPressed: Get.back,
                                                      child: const Text('OK'),
                                                    ),
                                                  );
                                                });
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.yarnInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Set Up Site Deployer'),
                    isActive: wctrl.currentStep >= 5,
                    state: wctrl.currentStep >= 5
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Netlify',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          final path = PathEnv.get();
                                          const command = 'netlify';

                                          final env = <String, String>{
                                            'PATH': path,
                                          };
                                          final cmdInstalled = whichSync(
                                            command,
                                            environment: (Platform.isWindows)
                                                ? null
                                                : env,
                                          );
                                          if (cmdInstalled != null) {
                                            wctrl.netlifyInstalled = true;

                                            await Get.defaultDialog(
                                              title: 'Step #6 Done:',
                                              middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                  .trim(),
                                              confirm: TextButton(
                                                onPressed: Get.back,
                                                child: const Text('OK'),
                                              ),
                                            );
                                          } else {
                                            final netlify = NetlifyInstall();
                                            await netlify(
                                              onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment:
                                                        (Platform.isWindows)
                                                            ? null
                                                            : env,
                                                  );
                                                  wctrl.netlifyInstalled = true;
                                                  Get.defaultDialog(
                                                    title: 'Step #6 Done:',
                                                    middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                        .trim(),
                                                    confirm: TextButton(
                                                      onPressed: Get.back,
                                                      child: const Text('OK'),
                                                    ),
                                                  );
                                                }
                                                controller.isLoading = false;
                                              },
                                            );
                                          }
                                        },
                                ),
                          checkbox: (wctrl.netlifyInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Download Default Site Theme'),
                    isActive: wctrl.currentStep >= 6,
                    state: wctrl.currentStep >= 6
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Install Thriftshop Site',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          controller.isLoading = true;
                                          if (wctrl.themeInstalled == false) {
                                            await Downloader.defaultTheme(
                                              onDone: (bool downloaded) {
                                                if (downloaded == true) {
                                                  wctrl.themeInstalled = true;
                                                  Get.snackbar(
                                                    'Step #7 Done',
                                                    'Theme Already Installed',
                                                  );
                                                  controller.isLoading = false;
                                                } else {
                                                  wctrl.themeInstalled = false;
                                                  Get.snackbar(
                                                    'Installation Failed',
                                                    'Please Try Again later',
                                                  );
                                                  controller.isLoading = false;
                                                }
                                              },
                                            );
                                          } else {
                                            Get.snackbar(
                                              'Step #7 Done',
                                              'Theme Already Installed',
                                            );
                                            controller.isLoading = false;
                                          }
                                        },
                                ),
                          checkbox: (wctrl.themeInstalled == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                  Step(
                    title: const Text('Create Account / Login Netlify'),
                    isActive: wctrl.currentStep >= 7,
                    state: wctrl.currentStep >= 7
                        ? StepState.complete
                        : StepState.disabled,
                    content: Column(
                      children: <Widget>[
                        OnboardingCard(
                          title: 'Login To Netlify',
                          button: controller.isLoading == true
                              ? CircularProgressIndicator(
                                  color: appColors[ACCENT],
                                )
                              : RunBtn(
                                  title: 'Run',
                                  icon: Icons.play_arrow,
                                  onTap: controller.isLoading == true
                                      ? null
                                      : () async {
                                          if (wctrl.netlifyLogged != true) {
                                            controller.isLoading = true;
                                            final login = NetlifyLogged();
                                            final response = await login();
                                            final message =
                                                response['message'] as String;
                                            if (response['url'] != null ||
                                                response['url'] != '') {
                                              await NetlifyLoginDialog(response)
                                                  .launch();
                                            } else if (message.isNotEmpty) {
                                              if (message.contains(
                                                'Already logged in',
                                              )) {
                                                wctrl.netlifyLogged = true;
                                              }
                                              Get.snackbar(
                                                'Netlify Account Authorized',
                                                response['message'] as String,
                                              );
                                              controller.isLoading = false;
                                            }
                                          } else {
                                            wctrl.netlifyLogged = true;

                                            Get.snackbar(
                                              'Netlify Account Authorized',
                                              'You can Proceed To Next Step',
                                            );
                                            controller.isLoading = false;
                                          }
                                        },
                                ),
                          checkbox: (wctrl.netlifyLogged == true)
                              ? const Icon(Icons.check_box)
                              : const Icon(Icons.check_box_outline_blank),
                        ),
                      ],
                    ),
                  ),
                ],
                currentStep: wctrl.currentStep,
                onStepContinue: wctrl.next,
                onStepTapped: wctrl.tap,
                onStepCancel: wctrl.cancel,
                controlsBuilder:
                    (BuildContext context, ControlsDetails controlsDetails) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: <Widget>[
                        if (wctrl.currentStep == 0 ||
                            controller.isLoading == true)
                          const SizedBox()
                        else
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.pink.shade100;
                                } else {
                                  return appColors[SECONDARY_DARK]!;
                                }
                              }),
                            ),
                            onPressed: wctrl.cancel,
                            child: const Text(
                              'Back',
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        const SizedBox(
                          width: 20,
                        ),
                        if (controller.isLoading == true)
                          const SizedBox()
                        else
                          ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                      (Set<MaterialState> states) {
                                if (states.contains(MaterialState.pressed)) {
                                  return Colors.purple.shade100;
                                } else {
                                  return appColors[PRIMARY_DARK]!;
                                }
                              }),
                            ),
                            onPressed: wctrl.next,
                            child: const Text(
                              'Next',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        );
      }),
    );
  }
}
