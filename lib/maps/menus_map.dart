import 'package:flutter/material.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/models/menu/menu_model.dart';

const Color defaultIconColor = Colors.white;

Icon topBarIcon(IconData icon, {Color color = defaultIconColor}) {
  return Icon(icon, color: color);
}

final List<Menu> Menus = <Menu>[
  Menu(
    name: 'Dashboard',
    route: '/home',
    icon: topBarIcon(Icons.dashboard, color: appColors[ACCENT_DARK]!),
  ),
  // Check Storage if we already have all steps done
  // Menu(
  //   name: 'Sites',
  //   route: '/sites',
  //   icon: topBarIcon(Icons.alternate_email, color: appColors[ACCENT_DARK]!),
  // ),
];
