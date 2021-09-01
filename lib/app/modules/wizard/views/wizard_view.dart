import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/components/onboarding_card.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/installers/pkg_manager_installer.dart';
import 'package:quatrokantos/installers/webi_installer.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/tob_bar.dart';

import '../controllers/wizard_controller.dart';

WizardController wizardController = Get.put(WizardController());

class WizardView extends GetView<WizardController> {
  final CommandController ctrl = Get.put(CommandController());
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TopBar(
        title: 'Thriftshop App Wizard Installation',
      ),
      body: Obx(() {
        if (controller.complete == false) {
          return Column(
            children: <Widget>[
              Expanded(
                child: Stepper(
                  steps: <Step>[
                    Step(
                      title: const Text('Set Up System Requirements'),
                      isActive: controller.currentStep >= 0,
                      state: controller.currentStep >= 0
                          ? StepState.complete
                          : StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          OnboardingCard(
                            title: 'Install Dev Tools',
                            checkbox: (controller.webiInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              final WebiInstall webi = WebiInstall();
                              webi(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.webiInstalled = true;
                                  Get.snackbar(
                                    'Notification',
                                    'First Step Done',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                          OnboardingCard(
                            title: 'Install System Package Manager',
                            checkbox: (controller.pkgInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () {
                              final PkgMangerInstall webi = PkgMangerInstall();
                              webi(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.pkgInstalled = true;
                                  Get.snackbar(
                                    'Notification',
                                    'Second Step Done',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Install Local Servers'),
                      isActive: controller.currentStep >= 1,
                      state: controller.currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          OnboardingCard(
                            title: 'Install Hugo',
                            checkbox: (controller.hugoInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () async {
                              final HugoInstall hugo = HugoInstall();
                              hugo(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.hugoInstalled = true;
                                  Get.snackbar(
                                    'Notification',
                                    'Third Step Done',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                          OnboardingCard(
                            title: 'Install Node',
                            checkbox: (controller.nodeInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () async {
                              final NodeInstall node = NodeInstall();
                              node(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.nodeInstalled = true;
                                  Get.snackbar(
                                    'Notification',
                                    'Fourth Step',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Set Up Site Manager'),
                      isActive: controller.currentStep >= 2,
                      state: controller.currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          OnboardingCard(
                            title: 'Install Netlify',
                            checkbox: (controller.netlifyInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () async {
                              final NetlifyInstall netlify = NetlifyInstall();
                              netlify(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.netlifyInstalled = true;
                                  Get.snackbar(
                                    'Notification',
                                    'Fifth Step Done',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                          OnboardingCard(
                            title: 'Sign Up/Login with Netlify',
                            checkbox: (controller.netlifyLogged == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () async {
                              final NetlifyLogged netlify = NetlifyLogged();
                              netlify(onDone: (
                                CommandController ctrl,
                                bool installed,
                              ) {
                                if (installed == true) {
                                  controller.netlifyLogged = true;
                                  Get.snackbar(
                                    'Notification',
                                    'Six Step Done',
                                    dismissDirection:
                                        SnackDismissDirection.HORIZONTAL,
                                  );
                                }
                              });
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                  currentStep: controller.currentStep,
                  onStepContinue: controller.next,
                  onStepTapped: controller.tap,
                  onStepCancel: controller.cancel,
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
                            onPressed: controller.cancel,
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
                            onPressed: controller.next,
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
