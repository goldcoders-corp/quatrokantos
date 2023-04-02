import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class MenuEntity extends Equatable {
  const MenuEntity({
    this.name,
    this.route,
    this.icon,
    this.callback,
    this.isAuth,
  });
  final String? name;
  final String? route;
  final Icon? icon;
  final Function? callback;
  final bool? isAuth;
  @override
  List<Object?> get props => <Object?>[name, route, icon, callback, isAuth];
}
