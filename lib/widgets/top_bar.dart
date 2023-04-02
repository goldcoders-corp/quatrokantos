// ignore_for_file: inference_failure_on_generic_invocation

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/routes/app_pages.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/env_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/maps/menus_map.dart';
import 'package:quatrokantos/models/menu/menu_model.dart';
import 'package:quatrokantos/widgets/btm_sheets.dart';

import '../../responsive.dart';

class TopBar extends StatelessWidget implements PreferredSizeWidget {
  TopBar({super.key, this.title, this.fontSize = 22.0});
  final String? title;
  final double? fontSize;
  final List<Menu> menus = Menus;

  @override
  Size get preferredSize => const Size.fromHeight(50);
  @override
  Widget build(BuildContext context) {
    var logo = dotenv.env[APP_LOGO];

    if (Get.currentRoute == Routes.WIZARD) {
      logo = 'assets/images/app.png';
    }
    return AppBar(
      title: RichText(
        text: TextSpan(
          text: title,
          style: TextStyle(color: Colors.white70, fontSize: fontSize),
        ),
      ),
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[
              appColors[COLOR2_DARK]!,
              appColors[COLOR1_DARK]!,
            ],
            stops: const <double>[0.5, 1],
          ),
        ),
      ),
      leading: Builder(
        builder: (BuildContext context) {
          if (Get.currentRoute == Routes.HOME ||
              Get.currentRoute == Routes.WIZARD) {
            return Padding(
              // ignore: prefer_const_constructors
              padding: EdgeInsets.only(left: 10),
              child: Image.asset(logo!, width: 50, height: 50),
            );
          } else {
            return Padding(
              padding: const EdgeInsets.only(left: 10),
              child: TextButton(
                onPressed: Get.back,
                child: const Icon(Icons.arrow_back, color: Colors.white),
              ),
            );
          }
        },
      ),
      actions: <Widget>[
        if (Get.currentRoute != Routes.WIZARD)
          if (Responsive.isDesktop(context) == false)
            TextButton(
              onPressed: () {
                triggerBottomSheet(menus);
              },
              child: const Icon(
                Icons.menu,
                color: Colors.white,
              ),
            ),
      ],
      centerTitle: true,
    );
  }
}
