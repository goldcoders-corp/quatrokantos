import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/kill_all.dart';
import 'package:quatrokantos/helpers/url_launcher_helper.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/models/netlify_account.dart';
import 'package:quatrokantos/netlify/netlify_api.dart';
import 'package:quatrokantos/services/netlify_auth_service.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

class NetlifyLoginDialog {
  final Map<String, dynamic> response;

  NetlifyLoginDialog(this.response);

  Future<dynamic> launch() {
    final CommandController controller = Get.find<CommandController>();

    final WizardController wctrl = Get.put(WizardController());
    final NetlifyAuthService netlify = Get.put(NetlifyAuthService());
    final String? url = response['url'] as String?;
    // final int? pid = response['pid'] as int?;
    // final int? exitCode = response['pid'] as int?;
    // final String message = response['message'] as String;
    return Get.defaultDialog(
        cancel: RunBtn(
            title: 'Cancel',
            onTap: () async {
              Get.back();
              final KillAll kill =
                  KillAll(unix_cmd: 'node', win_cmd: 'node.exe');
              final String output = await kill();
              Get.snackbar(
                'Notification',
                output,
                duration: const Duration(milliseconds: 30000),
                icon: const Icon(Icons.warning, color: Colors.red),
                snackPosition: SnackPosition.BOTTOM,
                dismissDirection: SnackDismissDirection.HORIZONTAL,
              );
              controller.isLoading = false;
            },
            icon: Icons.close),
        title: '',
        barrierDismissible: false,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 50),
          height: 400,
          width: 500,
          child: Column(
            children: <Widget>[
              const Text(
                'Link Your Netlify Account',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 50),
              const Text(
                'A URL Has Been Launched in the Browser',
              ),
              const SizedBox(height: 20),
              const Text(
                'If You Dont Have Account go Create One',
              ),
              const SizedBox(height: 20),
              const Text(
                'Once Logged In You May Re Launch the URL',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.open_in_browser,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Re-Open Authorization Link',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.purple[50],
                      primary: appColors[ACCENT],
                      onSurface: Colors.lightBlue,
                      elevation: 20,
                      minimumSize: const Size(350, 50),
                      shadowColor: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      if (url != null) {
                        await UrlLauncher(url: url)();
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Text(
                'Once App was Granted Authorization',
              ),
              const SizedBox(height: 20),
              const Text(
                'Click Button Below',
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ElevatedButton.icon(
                    icon: const Icon(
                      Icons.verified_user,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Verify Authorization was Granted',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      onPrimary: Colors.purple[50],
                      primary: appColors[ACCENT],
                      onSurface: Colors.lightBlue,
                      elevation: 20,
                      minimumSize: const Size(350, 50),
                      shadowColor: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      NetlifyApi.getCurrentUser(onDone: (String? userStr) {
                        if (userStr != '') {
                          final Map<String, dynamic> userMap =
                              json.decode(userStr!) as Map<String, dynamic>;

                          netlify.user = NetlifyAccount.fromJson(userMap);
                          if (netlify.user.name != '' &&
                              netlify.user.email != '' &&
                              netlify.user.id != '') {
                            wctrl.netlifyLogged = true;
                            Get.back();
                            controller.isLoading = false;
                            Get.snackbar('Well Done',
                                'You Have Completed The Last Step');
                          }
                        } else {
                          Get.snackbar('Account Not Yet Linked!',
                              'You Havent Authorized the App yet');
                        }
                      });
                    },
                  ),
                ],
              ),
            ],
          ),
        ));
  }
}
