import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/controllers/create_site_controller.dart';
import 'package:quatrokantos/app/modules/home/controllers/site_list_controller.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/routed_input_field.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

class CreateNewSiteDialog {
  static Future<dynamic> launch() {
    final SiteListController sitesCtrl = Get.put(SiteListController());
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
          padding: const EdgeInsets.symmetric(horizontal: 50),
          height: 350,
          width: 500,
          child: Column(
            children: <Widget>[
              Obx(() => Text(
                    (project.local_name == '')
                        ? 'Create New Site'
                        : 'My Site: ${project.local_name}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900),
                  )),
              const SizedBox(
                height: 50,
              ),
              RoundedInputField(
                hintText: "What's Your Project Name?",
                labelText: 'Site name',
                labelStyle: TextStyle(color: Colors.purple.shade300),
                helperText: 'e.g.: Project name',
                border: OutlineInputBorder(
                  gapPadding: 1.0,
                  borderRadius: const BorderRadius.all(Radius.circular(25.0)),
                  borderSide: BorderSide(color: Colors.purple.shade300),
                ),
                onChanged: (String value) {
                  project.local_name = value;
                },
              ),
              const SizedBox(height: 25.0),
              const Expanded(child: SizedBox()),
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
                      //TODO: Submit Using a Command
                      // validate form check if not empty
                      // check if valid domain format
                      // await project.add();
                      // TODO: fix this by adding the new sites to local
                      // await sitesCtrl.fetchSites();
                      Get.back();
                    },
                  );
                } else {
                  return CircularProgressIndicator(
                    color: Colors.red[200],
                  );
                }
              }),
              const SizedBox(
                height: 50,
              )
            ],
          ),
        ));
  }
}
