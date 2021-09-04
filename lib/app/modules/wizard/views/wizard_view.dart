import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/components/onboarding_card.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pkg_manager.dart';
import 'package:quatrokantos/installers/hugo_installer.dart';
import 'package:quatrokantos/installers/netlify_install.dart';
import 'package:quatrokantos/installers/node_installer.dart';
import 'package:quatrokantos/installers/pkg_manager_installer.dart';
import 'package:quatrokantos/installers/webi_installer.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/netlify/netlify_login.dart';
import 'package:quatrokantos/widgets/run_btn.dart';
import 'package:quatrokantos/widgets/tob_bar.dart';

import '../controllers/wizard_controller.dart';

class WizardView extends GetView<CommandController> {
  final WizardController wctrl = Get.find<WizardController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Thriftshop App Wizard Installation',
      ),
      body: Obx(() {
        if (wctrl.complete == false) {
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
                                        ? () {}
                                        : () async {
                                            final String path = PathEnv.get();
                                            const String command = 'webi';

                                            final Map<String, String> env =
                                                <String, String>{
                                              'PATH': path,
                                            };
                                            final String? cmdInstalled =
                                                whichSync(
                                              command,
                                              environment: env,
                                            );
                                            if (cmdInstalled != null) {
                                              wctrl.webiInstalled = true;
                                              Get.defaultDialog(
                                                  title: 'Step #1 Done:',
                                                  middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final WebiInstall webi =
                                                  WebiInstall();
                                              await webi(onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final String? cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment: env,
                                                  );
                                                  wctrl.webiInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #1 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                                        ? () {}
                                        : () async {
                                            final String path = PathEnv.get();
                                            final String pkgmanager =
                                                PackageManager.get();
                                            final Map<String, String> env =
                                                <String, String>{
                                              'PATH': path,
                                            };
                                            final String? cmdInstalled =
                                                whichSync(
                                              pkgmanager,
                                              environment: env,
                                            );
                                            if (cmdInstalled != null) {
                                              wctrl.pkgInstalled = true;

                                              Get.defaultDialog(
                                                  title: 'Step #2 Done:',
                                                  middleText: '''
${pkgmanager.toUpperCase()} Installed at
$cmdInstalled
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final PkgMangerInstall
                                                  pkgInstaller =
                                                  PkgMangerInstall();
                                              await pkgInstaller(onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final String? cmdInstalled =
                                                      whichSync(
                                                    pkgmanager,
                                                    environment: env,
                                                  );
                                                  wctrl.pkgInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #2 Done:',
                                                      middleText: '''
${pkgmanager.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                                        ? () {}
                                        : () async {
                                            final String path = PathEnv.get();
                                            const String command = 'hugo';

                                            final Map<String, String> env =
                                                <String, String>{
                                              'PATH': path,
                                            };
                                            final String? cmdInstalled =
                                                whichSync(
                                              command,
                                              environment: env,
                                            );
                                            if (cmdInstalled != null) {
                                              wctrl.hugoInstalled = true;

                                              Get.defaultDialog(
                                                  title: 'Step #3 Done:',
                                                  middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final HugoInstall hugoInstaller =
                                                  HugoInstall();
                                              await hugoInstaller(onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final String? cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment: env,
                                                  );
                                                  wctrl.hugoInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #3 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                                        ? () {}
                                        : () async {
                                            final String path = PathEnv.get();
                                            const String command = 'node';

                                            final Map<String, String> env =
                                                <String, String>{
                                              'PATH': path,
                                            };
                                            final String? cmdInstalled =
                                                whichSync(
                                              command,
                                              environment: env,
                                            );
                                            if (cmdInstalled != null) {
                                              wctrl.nodeInstalled = true;

                                              Get.defaultDialog(
                                                  title: 'Step #4 Done:',
                                                  middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final NodeInstall nodeInstaller =
                                                  NodeInstall();
                                              await nodeInstaller(onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final String? cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment: env,
                                                  );
                                                  wctrl.nodeInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #4 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                      title: const Text('Set Up Site Deployer'),
                      isActive: wctrl.currentStep >= 4,
                      state: wctrl.currentStep >= 4
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
                                        ? () {}
                                        : () async {
                                            final String path = PathEnv.get();
                                            const String command = 'netlify';

                                            final Map<String, String> env =
                                                <String, String>{
                                              'PATH': path,
                                            };
                                            final String? cmdInstalled =
                                                whichSync(
                                              command,
                                              environment: env,
                                            );
                                            if (cmdInstalled != null) {
                                              wctrl.netlifyInstalled = true;

                                              Get.defaultDialog(
                                                  title: 'Step #5 Done:',
                                                  middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final NetlifyInstall netlify =
                                                  NetlifyInstall();
                                              await netlify(onDone: (
                                                bool installed,
                                              ) {
                                                if (installed == true) {
                                                  final String? cmdInstalled =
                                                      whichSync(
                                                    command,
                                                    environment: env,
                                                  );
                                                  wctrl.netlifyInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #5 Done:',
                                                      middleText: '''
${command.toUpperCase()} Installed at
$cmdInstalled
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                      title: const Text('Create Account / Login Netlify'),
                      isActive: wctrl.currentStep >= 5,
                      state: wctrl.currentStep >= 5
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
                                        ? () {}
                                        : () async {
                                            if (wctrl.netlifyLogged == true) {
                                              Get.defaultDialog(
                                                  title: 'Step #6 Done:',
                                                  middleText: '''
You already Logged In to Netlify
'''
                                                      .trim(),
                                                  confirm: TextButton(
                                                    onPressed: () {
                                                      Get.back();
                                                    },
                                                    child: const Text('OK'),
                                                  ));
                                            } else {
                                              final NetlifyLogged logged =
                                                  NetlifyLogged();
                                              await logged(onDone: (
                                                bool logged,
                                              ) {
                                                if (logged == true) {
                                                  wctrl.netlifyLogged = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #6 Done:',
                                                      middleText: '''
You Have Successfully Logged In to Netlify
'''
                                                          .trim(),
                                                      confirm: TextButton(
                                                        onPressed: () {
                                                          Get.back();
                                                        },
                                                        child: const Text('OK'),
                                                      ));
                                                }
                                                controller.isLoading = false;
                                              });
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
                  controlsBuilder: (
                    BuildContext context, {
                    VoidCallback? onStepCancel,
                    VoidCallback? onStepContinue,
                    VoidCallback? onStepTapped,
                  }) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20.0),
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
                            width: 20.0,
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
        } else {
          return Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  const Text('Your All Set!'),
                  const SizedBox(height: 50),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.resolveWith<Color>(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.pressed)) {
                          return Colors.purple.shade100;
                        } else {
                          return appColors[PRIMARY_DARK]!;
                        }
                      }),
                    ),
                    onPressed: () {
                      Get.toNamed('/home');
                    },
                    child: const Text(
                      'Next',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        }
      }),
    );
  }
}
