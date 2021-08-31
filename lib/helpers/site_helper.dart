import 'dart:convert';
import 'dart:io';

class SiteHelper {
  /// #### To Be Used With Command Helper to Execute `NPM Scripts`
  /// ```
  /// final String packageJson =
  /// p.join(PC.userDirectory, 'Code', 'Goldcoders', 'site', 'package.json');
  ///
  ///    final Map<String, dynamic> packages =
  ///      await SiteHelper.getPackageJSON(packageJson);
  ///
  ///    final Map<String, dynamic> scripts =
  ///        packages['scripts'] as Map<String, dynamic>;
  ///
  ///    scripts.forEach((String key, dynamic script) {
  ///      // TODO: Save this on local db or as GetX route middleware
  ///      // command: npm
  ///      // args: ['$key'];
  ///      // cmd.execute()
  ///      print('key: $key , script: $script');
  ///    });
  /// ```
  static Future<Map<String, dynamic>> getPackageJSON(String projectPath) async {
    final String contents = await File(projectPath).readAsString();
    return json.decode(contents) as Map<String, dynamic>;
  }
}
