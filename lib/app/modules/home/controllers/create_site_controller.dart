// ignore_for_file: non_constant_identifier_names, depend_on_referenced_packages

import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/app/modules/home/controllers/site_list_controller.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

class CreateSiteController extends GetxController {
  final RxString _local_name = ''.obs;
  final RxString _name = ''.obs;
  final RxString _path = ''.obs;
  final RxBool _isLoading = false.obs;
  final RxString _custom_domain = ''.obs;

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  void resetFields() {
    _local_name.value = '';
    _name.value = '';
    _path.value = '';
    _custom_domain.value = '';
  }

  String get name => _name.value;
  set name(String val) => _name.value = val;

  String get custom_domain => _custom_domain.value;
  set custom_domain(String val) => _custom_domain.value = val;

  String get local_name => _local_name.value;
  set local_name(String val) => _local_name.value = val;

  String get path => _path.value;
  set path(String val) => _path.value = val;

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  String randomString(int length) {
    final rnd = Random();
    // ignore: always_specify_types
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => _chars.codeUnitAt(rnd.nextInt(_chars.length)),
      ),
    );
  }

  void _setUpFolder() {
    var appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    final appText = ReplaceHelper(text: appFolder, regex: r'\s+');
    appFolder = appText.replace();

    final folderText =
        ReplaceHelper(text: local_name.toLowerCase(), regex: r'\s+', str: '-');
    final folder = folderText.replace();

    path = p.join(
      PC.userDirectory,
      '.local',
      'share',
      '.$appFolder',
      'sites',
      folder,
    );
    final netlifyfolder = p.join(path, '.netlify');
    PathHelper.mkd(netlifyfolder);
  }

  Future<void> addSite(Map<String, dynamic> siteDetails) async {
    final ctrl = Get.put(SiteListController());
    _setUpFolder();
    final siteId = siteDetails['id'] as String;
    final site = Site(
      name: local_name,
      path: path, // setUpFolder invoked
      linked: true, // set to true since we call linkSite(siteId)
      details: SiteDetails(
        account_slug: siteDetails['account_slug'] as String,
        default_domain: siteDetails['default_domain'] as String,
        id: siteId,
        name: siteDetails['name'] as String,
        custom_domain: custom_domain,
        repo_url: siteDetails['repo_url'] as String?,
      ),
    );
    ctrl.sites.value.add(site);
    await linkSite(siteId);
    ctrl.saveLocal(json.encode(ctrl.sites.value));
    ctrl.sites.refresh();
    // ignore: inference_failure_on_function_invocation
    Get
      // ignore: inference_failure_on_function_invocation
      ..back()
      ..snackbar(
        'Success!',
        'Site Created: $custom_domain',
        icon: const Icon(Icons.check_circle_outline),
      );
    resetFields();
  }

  Future<void> linkSite(String siteId) async {
    if (path != '') {
      final stateFile = p.join(path, '.netlify', 'state.json');
      final content = '''
{
    "siteId": "$siteId"
}''';
      final file = await File(stateFile).create(recursive: true);
      file.writeAsStringSync(content);
    }
  }
}
