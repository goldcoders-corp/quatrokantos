import 'package:equatable/equatable.dart';

class NetlifyAccountEntity extends Equatable {
  // from getAccountSlug Netlify Api
  // slug is computed as follow
  // uses the full name as default if there is no slug
  // if there is not full name, uses the email as slug instead

  const NetlifyAccountEntity({
    required this.id,
    required this.name,
    required this.avatar,
    required this.email,
    required this.slug,
  });
  // from getCurrentUser Netliyf Api
  final String id;
  final String name;
  final String avatar;
  final String email;
  final String slug;

  @override
  List<Object?> get props => <Object?>[id, name, avatar, email, slug];
}

class NetlifyAccount extends NetlifyAccountEntity {
  const NetlifyAccount({
    required super.id,
    required super.name,
    required super.avatar,
    required super.email,
    required super.slug,
  });

  factory NetlifyAccount.fromJson(Map<String, dynamic> json) {
    var accountName = '';
    if (json.containsKey('full_name')) {
      accountName = json['full_name'] as String;
    }
    if (json.containsKey('name')) {
      accountName = json['name'] as String;
    }
    return NetlifyAccount(
      id: json['id'] as String,
      name: accountName,
      avatar: json['avatar'] as String,
      email: json['email'] as String,
      slug: json['slug'] == null ? '' : json['slug'] as String,
    );
  }

  Map<String, String> toJson() {
    return <String, String>{
      'id': id,
      'name': name,
      'avatar': avatar,
      'email': email,
      'slug': slug,
    };
  }
}
