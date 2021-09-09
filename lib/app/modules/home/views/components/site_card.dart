import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/controllers/site_list_controller.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/helpers/folder_launcher.dart';
import 'package:quatrokantos/helpers/url_launcher_helper.dart';
import 'package:quatrokantos/maps/app_colors.dart';

class SiteCard extends GetView<SiteListController> {
  const SiteCard({
    Key? key,
    required this.site,
  }) : super(key: key);

  final Site site;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: appColors[SECONDARY]!.withOpacity(0.13),
        borderRadius: const BorderRadius.all(Radius.circular(5)),
      ),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () async {
                      if (site.details?.id != null) {
                        await controller.deleteSite(site.details!.id);
                      }
                    },
                    child: Icon(
                      Icons.delete_forever_rounded,
                      color: Colors.redAccent[100],
                    )),
              )
            ],
          ),
          const SizedBox(height: 25),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                site.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const SizedBox(
            height: 45,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // SizedBox(
              //   height: 40,
              //   width: 40,
              //   child: TextButton(
              //       onPressed: () {
              //         Get.snackbar('Cloning Site', 'Copying Theme');
              //       },
              //       // TODO: /Users/uriah/Code/Goldcoders/site/.netlify/state.json
              //       // Read this json file from path provided
              //       // then find by id
              //       child: Obx(() => Icon(
              //             (controller.findByID(site.id!)?.id == null)
              //                 ? Icons.link_rounded
              //                 : Icons.file_download,
              //             color: (controller.findByID(site.id!)?.id == null)
              //                 ? appColors[ACCENT_DARK]
              //                 : Colors.white24,
              //           ))),
              // ),
              // SizedBox(
              //   height: 40,
              //   width: 40,
              //   child: TextButton(
              //       onPressed: () {
              //         Get.snackbar('Linking Site', 'Site will be Linked');
              //       },
              //       // TODO: /Users/uriah/Code/Goldcoders/site/.netlify/state.json
              //       // Read this json file from path provided
              //       // then find by id
              //       child: Obx(() => Icon(
              //             (controller.findByID(site.id!)?.id == null)
              //                 ? Icons.link_rounded
              //                 : Icons.verified,
              //             color: (controller.findByID(site.id!)?.id == null)
              //                 ? appColors[ACCENT_DARK]
              //                 : Colors.green.shade200,
              //           ))),
              // ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () async {
                      if (site.details?.default_domain != null ||
                          site.details?.default_domain != '') {
                        final UrlLauncher openURL = UrlLauncher(
                            url: 'https://${site.details?.default_domain}');
                        await openURL();
                      } else {
                        final UrlLauncher openURL = UrlLauncher(
                            url: 'https://${site.details?.custom_domain}');
                        await openURL();
                      }
                    },
                    child: Icon(
                      Icons.travel_explore,
                      color: Colors.indigoAccent.shade100,
                    )),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      // TODO: check this after we finished
                      // Site Creation , we can then navigate to the extra page
                      final Map<String, String> params =
                          site.toJson() as Map<String, String>;
                      Get.toNamed('/project/${site.name}', parameters: params);
                    },
                    child: Icon(
                      Icons.folder_open,
                      color: appColors[ACCENT_DARK],
                    )),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      Get.snackbar('Deploying Site', 'Site Deploying');
                    },
                    child: Icon(
                      Icons.cloud_upload,
                      color: appColors[ACCENT_DARK],
                    )),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      Get.snackbar('Load All Functions', 'NPM Functions');
                    },
                    child: Icon(
                      Icons.functions,
                      color: appColors[ACCENT_DARK],
                    )),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      final Folder folder = Folder(name: site.path);
                      folder.open();
                    },
                    child: Icon(
                      Icons.folder_open,
                      color: appColors[ACCENT_DARK],
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
