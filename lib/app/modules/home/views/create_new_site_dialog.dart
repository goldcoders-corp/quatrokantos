import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/controllers/create_site_controller.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/netlify/netlify_api.dart';
import 'package:quatrokantos/widgets/routed_input_field.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

class CreateNewSiteDialog {
  static Future<dynamic> launch() {
    final CreateSiteController project = Get.put(CreateSiteController());

    return Get.defaultDialog(
        cancel: RunBtn(
            title: 'Close',
            onTap: () {
              Get.back();
            },
            icon: Icons.close),
        title: '',
        barrierDismissible: false,
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          height: 350,
          width: 500,
          child: Column(
            children: <Widget>[
              const Text(
                'Create New Site',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(
                height: 25,
              ),
              RoundedInputField(
                hintText: "What's your Project Name?",
                labelText: 'Project name',
                labelStyle: TextStyle(color: Colors.purple.shade300),
                helperText: 'Note: This is Used for Local Folder',
                border: OutlineInputBorder(
                  gapPadding: 1.0,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.purple.shade300),
                ),
                onChanged: (String value) {
                  project.local_name = value;
                },
              ),
              const SizedBox(height: 10.0),
              RoundedInputField(
                hintText: 'What Netlify site name do you want?',
                labelText: 'Site name',
                labelStyle: TextStyle(color: Colors.purple.shade300),
                helperText: 'Note: Must Be Unique',
                border: OutlineInputBorder(
                  gapPadding: 1.0,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.purple.shade300),
                ),
                onChanged: (String value) {
                  project.name = value;
                },
              ),
              const SizedBox(height: 10.0),
              RoundedInputField(
                hintText: 'What Domain you want for Live Site?',
                labelText: 'Domain Name',
                labelStyle: TextStyle(color: Colors.purple.shade300),
                helperText:
                    'It can be purchased at later time, e.g: goldcoders.dev',
                border: OutlineInputBorder(
                  gapPadding: 1.0,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.purple.shade300),
                ),
                onChanged: (String value) {
                  project.custom_domain = value;
                },
              ),
              const SizedBox(height: 10.0),
              Obx(() {
                if (project.isLoading == false) {
                  return ElevatedButton.icon(
                    icon: const Icon(
                      Icons.add_business,
                      color: Colors.white,
                    ),
                    label: const Text(
                      'Add New Site',
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
                      minimumSize: const Size(500, 50),
                      shadowColor: Colors.purple[100],
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30)),
                    ),
                    onPressed: () async {
                      if (project.local_name == '' ||
                          project.custom_domain == '' ||
                          project.name == '') {
                        Get.snackbar('Validation Error', '''
Please Fill Up All Fields
''');
                        return;
                      }
                      project.isLoading = true;
                      final Map<String, Map<String, String>> data =
                          <String, Map<String, String>>{
                        'body': <String, String>{
                          'name': project.name,
                          'custom_domain': project.custom_domain
                        }
                      };
                      final String bodyStr = json.encode(data);
                      await NetlifyApi.createSite(bodyStr,
                          onDone: (String? siteDetails) async {
                        if (siteDetails != null && siteDetails != '') {
                          final Map<String, dynamic> siteMap =
                              json.decode(siteDetails) as Map<String, dynamic>;
                          await project.addSite(siteMap);
                        }
                        project.isLoading = false;
                      }, onError: (String? error) {
                        if (error != null && error.isNotEmpty) {
                          Get.snackbar('Validation Error', '''
Site Name: ${project.local_name} or Domain Name: ${project.custom_domain} Already Taken
''');
                        }
                        project.isLoading = false;
                      });
                    },
                  );
                } else {
                  return CircularProgressIndicator(
                      color: appColors[ACCENT],
                      backgroundColor: Colors.white38);
                }
              }),
            ],
          ),
        ));
  }
}
