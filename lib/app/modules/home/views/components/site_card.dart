import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/helpers/url_launcher_helper.dart';
import 'package:quatrokantos/maps/app_colors.dart';

class SiteCard extends StatelessWidget {
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
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      Get.snackbar('Opening Folder', 'TBA soon!');
                    },
                    child: const Icon(
                      Icons.folder_open,
                      color: Colors.amber,
                    )),
              ),
              SizedBox(
                height: 40,
                width: 40,
                child: TextButton(
                    onPressed: () {
                      Get.toNamed('/project/${site.local_name}',
                          parameters: site.toJson());
                    },
                    child: Icon(
                      Icons.open_in_browser,
                      color: appColors[ACCENT_DARK],
                    )),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                site.local_name ?? '',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  site.custom_domain ?? site.default_domain!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(
                  height: 40,
                  width: 40,
                  child: TextButton(
                      onPressed: () async {
                        if (site.default_domain != '') {
                          final UrlLauncher openURL = UrlLauncher(
                              url: 'https://${site.default_domain}');
                          await openURL();
                        } else {
                          final UrlLauncher openURL =
                              UrlLauncher(url: 'https://${site.custom_domain}');
                          await openURL();
                        }
                      },
                      child: Icon(
                        Icons.search,
                        color: appColors[ACCENT_DARK],
                      )),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
