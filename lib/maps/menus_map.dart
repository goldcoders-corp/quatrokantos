import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/models/menu/menu_model.dart';
import 'package:quatrokantos/services/netlify_auth_service.dart';

const Color defaultIconColor = Colors.white;

Icon topBarIcon(IconData icon, {Color color = defaultIconColor}) {
  return Icon(icon, color: color);
}

NetlifyAuthService netlifyAuthService = Get.find<NetlifyAuthService>();

// ignore: non_constant_identifier_names
final List<Menu> Menus = <Menu>[
  Menu(
    name: 'Dashboard',
    route: '/home',
    icon: topBarIcon(Icons.dashboard, color: appColors[ACCENT_DARK]!),
  ),
  Menu(
    name: 'Logout',
    icon: topBarIcon(Icons.logout, color: appColors[ACCENT_DARK]!),
    isAuth: netlifyAuthService.isLogged,
    callback: () => netlifyAuthService.logout(),
  ),
];
