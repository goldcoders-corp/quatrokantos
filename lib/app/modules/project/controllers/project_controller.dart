import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/folder_launcher.dart';
import 'package:quatrokantos/helpers/path_helper.dart';

class ProjectController extends GetxController {
  final RxString _path = ''.obs;
  final RxString _local_name = ''.obs;
  final RxString _siteId = ''.obs;
  final RxBool _linked = false.obs;
  final RxBool _isLoading = false.obs;
  final RxString _custom_domain = ''.obs;
  final RxString _name = ''.obs;
  final RxString _account_slug = ''.obs;
  final RxString _default_domain = ''.obs;
  final RxString _repo_url = ''.obs;

  @override
  void onInit() {
    initData();
    initLinked();
    changeToProjectDirectory();
    super.onInit();
  }

  String get custom_domain => _custom_domain.value;
  set custom_domain(String val) => _custom_domain.value = val;

  String get name => _name.value;
  set name(String val) => _name.value = val;

  String get account_slug => _account_slug.value;
  set account_slug(String val) => _account_slug.value = val;

  String get default_domain => _default_domain.value;
  set default_domain(String val) => _default_domain.value = val;

  String get repo_url => _repo_url.value;
  set repo_url(String val) => _repo_url.value = val;

  String get siteId => _siteId.value;
  set siteId(String val) => _siteId.value = val;

  bool get linked => _linked.value;
  set linked(bool val) => _linked.value = val;

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  String get path => _path.value;
  set path(String val) => _path.value = val;

  String get local_name => _local_name.value;
  set local_name(String val) => _local_name.value = val;

  @override
  void onClose() {}

  /// Please Ensure You are Passing Arguments in your Name Route
  /// > For Example:
  /// ```
  /// Get.toNamed('/project/${site.name}',parameters: site.toJson());
  ///
  /// ```
  void initData() {
    local_name = Get.parameters['local_name'] ??= '';
    path = Get.parameters['path'] ??= '';

    siteId = Get.parameters['id'] ??= '';
    name = Get.parameters['name'] ??= '';
    custom_domain = Get.parameters['custom_domain'] ??= '';
    account_slug = Get.parameters['account_slug'] ??= '';
    default_domain = Get.parameters['default_domain'] ??= '';
    repo_url = Get.parameters['repo_url'] ??= '';
  }

  Future<void> changeToProjectDirectory() async {
    final String projectPath = Folder(name: local_name).folder();
    if (await PathHelper.exists(projectPath) == true) {
      PathHelper.cd(projectPath);
    }
  }

  Future<void> initLinked() async {
    // check if project folder has .netlify/state.json
    // if none create one , if yes read the file
    // check for a key "siteId"
    final String dotnetlify = p.join(local_name, '.netlify');

    final String netlifyFolder = Folder(name: dotnetlify).folder();

    final String netlifyFile = p.join(netlifyFolder, 'state.json');

    final bool exists = await File(netlifyFile).exists();

    if (exists) {
      final String file = await File(netlifyFile).readAsString();
      if (file.isNotEmpty) {
        final Map<String, dynamic> json =
            jsonDecode(file) as Map<String, dynamic>;
        // check json has key siteId
        if (json.containsKey('siteId')) {
          linked = true;
        }
      }
    } else {
      if (siteId.isNotEmpty) {
        final String netlifyconfig = '''
{
  "siteId": "$siteId"
}
'''
            .trim();
        // save netlify config back to file
        await File(netlifyFile).writeAsString(netlifyconfig);
        linked = true;
      }
    }
  }
}
