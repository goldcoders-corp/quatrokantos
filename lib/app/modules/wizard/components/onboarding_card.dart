import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/constants/color_constants.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/maps/app_colors.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    Key? key,
    required this.title,
    required this.checkbox,
    required this.widget,
  }) : super(key: key);

  final String title;
  final Widget checkbox;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: defaultPadding),
      padding: const EdgeInsets.all(defaultPadding),
      decoration: BoxDecoration(
        border: Border.all(
          width: 2,
          color: Theme.of(context).primaryColor.withOpacity(0.15),
        ),
        borderRadius: const BorderRadius.all(
          Radius.circular(defaultPadding),
        ),
      ),
      child: Row(
        children: <Widget>[
          checkbox,
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: defaultPadding),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ),
          widget
        ],
      ),
    );
  }
}
