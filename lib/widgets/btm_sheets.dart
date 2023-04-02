// ignore_for_file: inference_failure_on_function_invocation, lines_longer_than_80_chars, avoid_dynamic_calls

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/models/menu/menu_model.dart';

void triggerBottomSheet(List<Menu> menus) {
  Get.bottomSheet(
    Ink(
      color: appColors[BG_DARK]!.withOpacity(1),
      child: ListView.builder(
        itemCount: menus.length,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            leading: menus[index].icon,
            title: Text(
              menus[index].name!,
              style: const TextStyle(color: Colors.white),
            ),
            onTap: () {
              if (menus[index].route != null) {
                Get.offNamed(menus[index].route!);
              }
              if (menus[index].callback != null) {
                menus[index].callback?.call();
              }
            },
          );
        },
      ),
    ),
    backgroundColor: Colors.transparent,
  );
}
