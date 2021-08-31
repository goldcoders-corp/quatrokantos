import 'package:flutter/material.dart';
import 'package:outline_gradient_button/outline_gradient_button.dart';

class RunBtn extends StatelessWidget {
  final String title;
  final VoidCallback? onTap;

  Icon TouchIcon(IconData icon, Color color) {
    return Icon(icon, color: color);
  }

  final Color highlighColor;
  final Color splashColor;

  final Color gradient1;
  final Color gradient2;
  final double width;
  final double height;
  final double radius;
  final double fontSize;
  final IconData icon;
  final Color iconColor;

  const RunBtn({
    required this.title,
    // ignore: avoid_init_to_null
    this.onTap = null,
    this.height = 70,
    this.width = 70,
    this.radius = 35,
    this.fontSize = 10,
    this.gradient1 = const Color(0xFFFF4081),
    this.gradient2 = const Color(0xffb69859),
    this.highlighColor = Colors.white24,
    this.splashColor = Colors.black54,
    this.icon = Icons.add_link,
    this.iconColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      onTap: onTap,
      highlightColor: highlighColor,
      splashColor: splashColor,
      child: OutlineGradientButton(
        gradient: LinearGradient(
          colors: <Color>[
            gradient1,
            gradient2,
          ],
          // ignore: use_named_constants
          begin: const Alignment(-1, -1),
          end: const Alignment(2, 2),
        ),
        strokeWidth: 4,
        padding: EdgeInsets.zero,
        radius: Radius.circular(radius),
        child: SizedBox(
            width: width,
            height: height,
            child: MouseRegion(
              cursor: SystemMouseCursors.click,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  TouchIcon(icon, iconColor),
                  Text(title, style: TextStyle(fontSize: fontSize)),
                ],
              ),
            )),
      ),
    );
  }
}
