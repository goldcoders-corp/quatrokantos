import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/components/onboarding_card.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
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
                                            final String? cmdInstalled =
                                                whichSync('webi', environment: <
                                                    String, String>{
                                              'PATH': PathEnv.get()
                                            });
                                            if (cmdInstalled != null) {
                                              wctrl.webiInstalled = true;
                                              Get.defaultDialog(
                                                  title: 'Step #1 Done:',
                                                  middleText: '''
Webi Installed at
${whichSync('webi', environment: <String, String>{'PATH': PathEnv.get()})}
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
                                                  wctrl.webiInstalled = true;
                                                  Get.defaultDialog(
                                                      title: 'Step #1 Done:',
                                                      middleText: '''
Webi Installed at
${whichSync('webi', environment: <String, String>{'PATH': PathEnv.get()})}
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

                          // OnboardingCard(
                          //   title: 'Install System Package Manager',
                          //   checkbox: (wctrl.pkgInstalled == true)
                          //       ? const Icon(Icons.check_box)
                          //       : const Icon(Icons.check_box_outline_blank),
                          //   onTap: () {
                          //     final PkgMangerInstall webi = PkgMangerInstall();
                          //     webi(onDone: (
                          //       CommandController ctrl,
                          //       bool installed,
                          //     ) {
                          //       if (installed == true) {
                          //         wctrl.pkgInstalled = true;
                          //         Get.snackbar(
                          //           'Notification',
                          //           'Second Step Done',
                          //           dismissDirection:
                          //               SnackDismissDirection.HORIZONTAL,
                          //         );
                          //       }
                          //     });
                          //   },
                          // ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Install Local Servers'),
                      isActive: wctrl.currentStep >= 1,
                      state: wctrl.currentStep >= 1
                          ? StepState.complete
                          : StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          OnboardingCard(
                            title: 'Install Hugo',
                            checkbox: (wctrl.hugoInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            button: Container(),
//                             onTap: () async {
//                               final HugoInstall hugo = HugoInstall();
//                               hugo(onDone: (
//                                 CommandController controller,
//                                 bool installed,
//                               ) {
//                                 if (installed == true) {
//                                   wctrl.hugoInstalled = true;

//                                   Get.defaultDialog(
//                                       title: 'Step #3 Done:',
//                                       middleText: '''
// Hugo Installed at
// ${whichSync('hugo')}
//                                           '''
//                                           .trim(),
//                                       confirm: TextButton(
//                                         onPressed: () {
//                                           Get.back();
//                                         },
//                                         child: const Text('OK'),
//                                       ));
//                                 }
//                               });
//                             },
                          ),
                          OnboardingCard(
                            title: 'Install Node',
                            checkbox: (wctrl.nodeInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            button: Container(),
                            // onTap: () async {
                            //   final NodeInstall node = NodeInstall();
                            //   node(onDone: (
                            //     CommandController ctrl,
                            //     bool installed,
                            //   ) {
                            //     if (installed == true) {
                            //       wctrl.nodeInstalled = true;
                            //       Get.snackbar(
                            //         'Notification',
                            //         'Fourth Step',
                            //         dismissDirection:
                            //             SnackDismissDirection.HORIZONTAL,
                            //       );
                            //     }
                            //   });
                            // },
                          ),
                        ],
                      ),
                    ),
                    Step(
                      title: const Text('Set Up Site Manager'),
                      isActive: wctrl.currentStep >= 2,
                      state: wctrl.currentStep >= 2
                          ? StepState.complete
                          : StepState.disabled,
                      content: Column(
                        children: <Widget>[
                          OnboardingCard(
                            title: 'Install Netlify',
                            checkbox: (wctrl.netlifyInstalled == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            button: Container(),

                            // onTap: () async {
                            //   final NetlifyInstall netlify = NetlifyInstall();
                            //   netlify(onDone: (
                            //     CommandController controller,
                            //     bool installed,
                            //   ) {
                            //     if (installed == true) {
                            //       wctrl.netlifyInstalled = true;
                            //       Get.snackbar(
                            //         'Notification',
                            //         'Fifth Step Done',
                            //         dismissDirection:
                            //             SnackDismissDirection.HORIZONTAL,
                            //       );
                            //     }
                            //   });
                            // },
                          ),
                          OnboardingCard(
                            title: 'Sign Up/Login with Netlify',
                            checkbox: (wctrl.netlifyLogged == true)
                                ? const Icon(Icons.check_box)
                                : const Icon(Icons.check_box_outline_blank),
                            button: Container(),
                            // onTap: () async {
                            //   final NetlifyLogged netlify = NetlifyLogged();
                            //   netlify(onDone: (
                            //     bool installed,
                            //   ) {
                            //     if (installed == true) {
                            //       wctrl.netlifyLogged = true;
                            //       Get.snackbar(
                            //         'Notification',
                            //         'Six Step Done',
                            //         dismissDirection:
                            //             SnackDismissDirection.HORIZONTAL,
                            //       );
                            //     }
                            //   });
                            // },
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
                          if (wctrl.currentStep == 0)
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
