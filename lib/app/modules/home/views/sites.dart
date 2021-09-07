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
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
        child: Column(
          children: <Widget>[
            if (controller.sites.value.isNotEmpty)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Site Listings',
                    style: Theme.of(context).textTheme.headline5,
                  ),
                  RunBtn(
                      title: 'New Site',
                      icon: Icons.add_business,
                      onTap: () async {
                        await CreateNewSiteDialog.launch();
                      }),
                ],
              )
            else
              const SizedBox(
                height: defaultPadding,
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
            mainAxisExtent: 150,
          ),
          itemBuilder: (BuildContext context, int index) =>
              SiteCard(site: controller.sites.value[index]),
        );
      } else {
        return Center(
          child: Column(
            children: <Widget>[
              const Text(
                'Launch Your First Site',
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SvgPicture.asset('assets/svg/app_launch.svg',
                  width: 350.0,
                  height: 350.0,
                  semanticsLabel: 'Create Your First Site Now'),
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
                onPressed: () async {
                  await CreateNewSiteDialog.launch();
                },
                child: const Text(
                  'Create New Site`',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }
    });
  }
}
