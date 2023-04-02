import 'package:equatable/equatable.dart';

class CmsEntity extends Equatable {
  const CmsEntity({
    required this.name,
    required this.themeUrl,
    required this.cmsUrl,
  });
  final String name;
  final String themeUrl;
  final String cmsUrl;

  @override
  List<Object?> get props => <Object?>[name, themeUrl, cmsUrl];
}

class Cms extends CmsEntity {
  const Cms({
    required super.name,
    required super.themeUrl,
    required super.cmsUrl,
  });

  factory Cms.fromJson(Map<String, dynamic> json) {
    return Cms(
      name: json['name'] as String,
      themeUrl: json['themeUrl'] as String,
      cmsUrl: json['cmsUrl'] as String,
    );
  }

  Map<String, String> toJson() {
    return <String, String>{
      'name': name,
      'themeUrl': themeUrl,
      'cmsUrl': cmsUrl,
    };
  }
}
