import 'package:flutter/material.dart';
import 'package:quatrokantos/constants/default_size.dart';
import 'package:quatrokantos/widgets/run_btn.dart';

class OnboardingCard extends StatelessWidget {
  // ignore: prefer_const_constructors_in_immutables
  OnboardingCard({
    Key? key,
    required this.title,
    required this.checkbox,
    this.onTap,
  }) : super(key: key);

  final String title;
  final Widget checkbox;
  final VoidCallback? onTap;

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
          RunBtn(title: 'Run', onTap: onTap, icon: Icons.play_arrow),
        ],
      ),
    );
  }
}
