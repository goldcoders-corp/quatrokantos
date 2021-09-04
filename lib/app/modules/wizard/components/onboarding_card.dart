import 'package:flutter/material.dart';
import 'package:quatrokantos/constants/default_size.dart';

class OnboardingCard extends StatelessWidget {
  const OnboardingCard({
    Key? key,
    required this.title,
    required this.checkbox,
    required this.button,
  }) : super(key: key);

  final String title;
  final Widget checkbox;
  final Widget button;

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
          button,
        ],
      ),
    );
  }
}
