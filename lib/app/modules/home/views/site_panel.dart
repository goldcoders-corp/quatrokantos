import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/controllers/site_list_controller.dart';
import 'package:quatrokantos/app/modules/home/views/create_new_site_dialog.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

import '../../../../../responsive.dart';
import 'components/site_card.dart';

class SitePanel extends GetView<SiteListController> {
  const SitePanel({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Size _size = MediaQuery.of(context).size;
    final SiteListController sitesCtrl = Get.put(SiteListController());

    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: <Widget>[
            if (controller.sites.value.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    'Site Listings',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                ],
              )
            else
              const SizedBox(
                height: defaultPadding,
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RunBtn(
                    title: 'New Site',
                    icon: Icons.add_business,
                    onTap: () async {
                      await CreateNewSiteDialog.launch();
                    }),
                Obx(
                  () => (sitesCtrl.isLoading == false)
                      ? RunBtn(
                          title: 'Clear All',
                          icon: Icons.auto_delete_outlined,
                          onTap: () async {
                            Get.defaultDialog(
                              barrierDismissible: false,
                              cancel: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.white70,
                                  primary: appColors[BG],
                                  onSurface: Colors.white,
                                  minimumSize: const Size(150, 50),
                                  shadowColor: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                label: const Text('Cancel'),
                                icon: const Icon(Icons.arrow_back),
                                onPressed: () async {
                                  Get.back();
                                },
                              ),
                              title: '',
                              contentPadding: const EdgeInsets.all(20),
                              content: SizedBox(
                                width: 450,
                                height: 125,
                                child: Column(
                                  children: const <Widget>[
                                    Text(
                                      'You Are About to Delete All Sites.',
                                      style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                      ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('''
Live and Local Sites Will Be Wiped Out!'''),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('This action cannot be undone.'),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text('Are you sure you want to continue?'),
                                  ],
                                ),
                              ),
                              confirm: ElevatedButton.icon(
                                style: ElevatedButton.styleFrom(
                                  onPrimary: Colors.red[50],
                                  primary: Colors.red[500],
                                  onSurface: Colors.white,
                                  minimumSize: const Size(150, 50),
                                  shadowColor: Colors.black45,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                label: const Text('Confirm'),
                                icon: const Icon(Icons.delete),
                                onPressed: () async {
                                  await sitesCtrl.uninstallSites();
                                  Get.back();
                                },
                              ),
                            );
                          })
                      : SizedBox(
                          height: 70,
                          width: 70,
                          child: CircularProgressIndicator(
                            color: Colors.indigo.shade200,
                          ),
                        ),
                ),
              ],
            ),
            const SizedBox(height: defaultPadding),
            Responsive(
              mobile: SiteCardGridView(
                crossAxisCount: _size.width < 650 ? 1 : 2,
                childAspectRatio: _size.width < 650 ? 1.3 : 1,
              ),
              tablet: const SiteCardGridView(),
              desktop: SiteCardGridView(
                childAspectRatio: _size.width < 1400 ? 1.1 : 1.4,
              ),
            )
          ],
        ),
      );
    });
  }
}

class SiteCardGridView extends GetView<SiteListController> {
  const SiteCardGridView({
    Key? key,
    this.crossAxisCount = 3,
    this.childAspectRatio = 1,
  }) : super(key: key);

  final int crossAxisCount;
  final double childAspectRatio;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.sites.value.isNotEmpty) {
        return GridView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: controller.sites.value.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: defaultPadding,
            mainAxisSpacing: defaultPadding,
            childAspectRatio: childAspectRatio,
            mainAxisExtent: 200,
          ),
          itemBuilder: (BuildContext context, int index) =>
              SiteCard(site: controller.sites.value[index]),
        );
      } else {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Column(
              children: <Widget>[
                const Text(
                  'Create Your First Site',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                SvgPicture.asset('assets/svg/build_site.svg',
                    width: 350.0,
                    height: 350.0,
                    semanticsLabel: 'Create Your First Site Now'),
              ],
            ),
          ),
        );
      }
    });
  }
}
