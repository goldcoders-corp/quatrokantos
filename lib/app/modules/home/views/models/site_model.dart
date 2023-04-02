// ignore_for_file: non_constant_identifier_names

import 'package:equatable/equatable.dart';

class SiteDetailsEntity extends Equatable {
  const SiteDetailsEntity({
    required this.id,
    required this.name,
    required this.account_slug,
    required this.default_domain,
    this.repo_url,
    this.custom_domain,
  });
  final String id;
  final String name;
  final String account_slug;
  final String default_domain;
  final String? repo_url;
  final String? custom_domain;

  @override
  List<Object?> get props => <Object?>[
        id,
        name,
        account_slug,
        default_domain,
        repo_url,
        custom_domain,
      ];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'id': id,
        'account_slug': account_slug,
        'default_domain': default_domain,
        'repo_url': repo_url,
        'custom_domain': custom_domain,
      };
}

class SiteDetails extends SiteDetailsEntity {
  const SiteDetails({
    required super.id,
    required super.name,
    required super.account_slug,
    required super.default_domain,
    super.repo_url,
    super.custom_domain,
  });

  factory SiteDetails.fromJson(Map<String, dynamic> json) {
    return SiteDetails(
      id: json['id'] as String,
      name: json['name'] as String,
      account_slug: json['account_slug'] as String,
      default_domain: json['default_domain'] as String,
      repo_url: json['repo_url'] as String?,
      custom_domain: json['custom_domain'] as String?,
    );
  }
}

class SiteEntity extends Equatable {
  const SiteEntity({
    required this.name,
    required this.path,
    required this.linked,
    this.details,
  });
  final String name;
  final String path;
  final bool linked;
  final SiteDetailsEntity? details;

  @override
  List<Object?> get props => <Object?>[name, path, linked, details];

  Map<String, dynamic> toJson() => <String, dynamic>{
        'name': name,
        'path': path,
        'linked': linked,
        'details': details?.toJson(),
      };
}

class Site extends SiteEntity {
  const Site({
    required super.name,
    required super.path,
    required super.linked,
    SiteDetails? super.details,
  });
  factory Site.fromJson(Map<String, dynamic> json) => Site(
        name: json['name'] as String,
        path: json['path'] as String,
        linked: json['linked'] as bool,
        details: SiteDetails.fromJson(json['details'] as Map<String, dynamic>),
      );
}
