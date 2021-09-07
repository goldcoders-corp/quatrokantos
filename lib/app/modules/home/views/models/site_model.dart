import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

class Site {
  // will be field up from form field
  String? local_name;
  String? custom_domain;
  String? path;
  // below can be sync when online
  String? id;
  String? name;
  String? account_slug;
  String? default_domain;
  String? repo_url;

  Site({
    this.local_name,
    this.custom_domain,
    this.path,
    // all params below from netlify
    // netlify sites:list --json

    this.id = '', //  id
    this.name = '', //  name
    this.account_slug = '', // account_slug
    this.default_domain = '', // default_domain
    this.repo_url = '', // build_settings.repo_url
  }) {
    local_name ??= name;
    custom_domain = custom_domain ?? default_domain;
    path ??= (name != null) ? cwd(name!) : '';
  }

  static String cwd(String name) {
    String folder = dotenv.env['APP_NAME']!.toLowerCase();
    final ReplaceHelper text = ReplaceHelper(text: folder, regex: '\\s+');
    folder = text.replace();
    final String cwd =
        p.join(PC.userDirectory, '.local', 'share', '.$folder', 'sites', name);
    // PathHelper.mkd(cwd);

    return cwd;
  }

  // publish_deploy.site_capabilities.functions.invocations.used
  // capabilities.functions.invocations.included
  // capabilities.functions.runtime.included
  // capabilities.functions.runtime.used

  factory Site.fromJson(Map<String, dynamic> json) => Site(
        local_name: json['local_name'] as String?,
        custom_domain: json['custom_domain'] as String?,
        path: json['path'] as String?,
        id: json['id'] as String?,
        name: json['name'] as String?,
        account_slug: json['account_slug'] as String?,
        default_domain: json['default_domain'] as String?,
        repo_url: json['repo_url'] as String?,
      );

  Map<String, String> toJson() => <String, String>{
        'local_name': local_name ??= '',
        'custom_domain': custom_domain ??= '',
        'path': path ??= '',
        'id': id ??= '',
        'name': name ??= '',
        'account_slug': account_slug ??= '',
        'default_domain': default_domain ??= '',
        'repo_url': repo_url ??= '',
      };
}
