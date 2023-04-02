import 'package:flutter/widgets.dart';
import 'package:quatrokantos/models/menu/menu_entity.dart';

class Menu extends MenuEntity {
  const Menu({
    super.name,
    super.route,
    super.icon,
    super.callback,
    super.isAuth,
  });

  factory Menu.fromJson(Map<String, dynamic> json) => Menu(
        name: json['name'] as String?,
        route: json['route'] as String?,
        icon: json['icon'] as Icon?,
        callback: json['callback'] as Function?,
        isAuth: json['isAuth'] as bool?,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'route': route,
        'icon': icon,
        'callback': callback,
        'isAuth': isAuth,
      };
}
