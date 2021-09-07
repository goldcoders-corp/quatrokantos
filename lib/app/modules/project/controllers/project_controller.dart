import 'dart:io';
import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

class ProjectController extends GetxController {
  final RxString _local_name = ''.obs;
  final RxString _path = ''.obs;
  final RxString _custom_domain = ''.obs;
  final RxString _id = ''.obs;
  final RxString _name = ''.obs;
  final RxString _account_slug = ''.obs;
  final RxString _default_domain = ''.obs;
  final RxString _repo_url = ''.obs;

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  @override
  void onInit() {
    initData();
    super.onInit();
  }

  String get local_name => _local_name.value;
  set local_name(String val) => _local_name.value = val;

  String get path => _path.value;
  set path(String val) => _path.value = val;

  String get custom_domain => _custom_domain.value;
  set custom_domain(String val) => _custom_domain.value = val;

  String get id => _id.value;
  set id(String val) => _id.value = val;

  String get name => _name.value;
  set name(String val) => _name.value = val;

  String get account_slug => _account_slug.value;
  set account_slug(String val) => _account_slug.value = val;

  String get default_domain => _default_domain.value;
  set default_domain(String val) => _default_domain.value = val;

  String get repo_url => _repo_url.value;
  set repo_url(String val) => _repo_url.value = val;

  @override
  void onClose() {}

  /// Please Ensure You are Passing Arguments in your Name Route
  /// > For Example:
  /// ```
  /// Get.toNamed('/project/${site.id}',parameters: site.toJson());
  ///
  /// ```
  void initData() {
    local_name = Get.parameters['local_name'] ??= '';
    print(id);
    path = Get.parameters['path'] ??= '';
    custom_domain = Get.parameters['custom_domain'] ??= '';
    id = Get.parameters['id'] ??= '';
    name = Get.parameters['name'] ??= '';
    account_slug = Get.parameters['account_slug'] ??= '';
    default_domain = Get.parameters['default_domain'] ??= '';
    repo_url = Get.parameters['repo_url'] ??= '';

    print(id);
  }

  void updateCWD() {
    String folder = name;
    if (name.isEmpty || name == '') {
      // use our local name folder
      final ReplaceHelper text = ReplaceHelper(text: local_name, regex: '\\s+');
      folder = text.replace();
      folder = local_name;
    }
    PathHelper.mkd(folder);

    final String cwd = p.join(getSitesFolder(), folder);
    print(cwd);
    Directory.current = cwd;
  }

  static String getSitesFolder() {
    String folder = dotenv.env['APP_NAME']!.toLowerCase();
    final ReplaceHelper text = ReplaceHelper(text: folder, regex: '\\s+');
    folder = text.replace();
    final String cwd =
        p.join(PC.userDirectory, '.local', 'share', '.$folder', 'sites');
    return cwd;
  }

  String randomString(int length) {
    final Random _rnd = Random();
    // ignore: always_specify_types
    return String.fromCharCodes(Iterable.generate(
        length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
  }

  void _setUpFolder() {
    String appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    final ReplaceHelper appText = ReplaceHelper(text: appFolder, regex: '\\s+');
    appFolder = appText.replace();

    final ReplaceHelper folderText =
        ReplaceHelper(text: local_name, regex: '\\s+');
    final String folder = folderText.replace();

    path = p.join(
      PC.userDirectory,
      '.local',
      'share',
      '.$appFolder',
      'sites',
      folder,
    );
    PathHelper.mkd(path);
  }
}
