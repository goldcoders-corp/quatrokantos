import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

class MenuEntity extends Equatable {
  final String? name;
  final String? route;
  final Icon? icon;
  final Function? callback;
  final bool? isAuth;

  const MenuEntity(
      {this.name, this.route, this.icon, this.callback, this.isAuth});
  @override
  List<Object?> get props => <Object?>[name, route, icon, callback, isAuth];
}
