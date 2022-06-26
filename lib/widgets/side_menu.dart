import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/maps/menus_map.dart';
import 'package:quatrokantos/models/menu/menu_model.dart';

class SideMenu extends StatelessWidget {
  const SideMenu({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Menu> menus = Menus;
    return Drawer(
        child: Container(
      color: appColors[BG_DARK],
      child: ListView(
        shrinkWrap: true,
        children: <Widget>[
          DrawerHeader(
              child: CircleAvatar(
            backgroundColor: Colors.black26,
            child: Image.asset(
              'assets/images/app.png',
              width: 125,
              height: 125,
            ),
          )),
          ListView.builder(
            shrinkWrap: true,
            itemCount: menus.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                leading: menus[index].icon,
                title: Text(
                  menus[index].name!,
                  style: TextStyle(
                      color: appColors[ACCENT_DARK]!.withOpacity(0.5)),
                ),
                onTap: () {
                  if (menus[index].route != null) {
                    Get.toNamed(menus[index].route!);
                  }
                  if (menus[index].callback != null) {
                    menus[index].callback!();
                  }
                },
              );
            },
          ),
        ],
      ),
    ));
  }
}

class DrawerListTile extends StatelessWidget {
  const DrawerListTile({
    Key? key,
    // For selecting those three line once press "Command+D"
    required this.title,
    required this.svgSrc,
    required this.press,
  }) : super(key: key);

  // ignore: avoid_multiple_declarations_per_line
  final String title, svgSrc;
  final VoidCallback press;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: press,
      horizontalTitleGap: 0.0,
      leading: SvgPicture.asset(
        svgSrc,
        color: Colors.white54,
        height: 16,
      ),
      title: Text(
        title,
        style: const TextStyle(color: Colors.white54),
      ),
    );
  }
}
