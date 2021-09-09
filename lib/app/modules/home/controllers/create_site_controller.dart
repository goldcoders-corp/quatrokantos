import 'dart:math';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/app/modules/home/controllers/site_list_controller.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';
import 'package:quatrokantos/netlify/netlify_site_create.dart';

class CreateSiteController extends GetxController {
  final RxString _local_name = ''.obs;
  final RxString _path = ''.obs;
  final RxBool _isLoading = false.obs;

  static const String _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';

  String get local_name => _local_name.value;
  set local_name(String val) => _local_name.value = val;

  String get path => _path.value;
  set path(String val) => _path.value = val;

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  @override
  void onInit() {
    super.onInit();
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
        ReplaceHelper(text: local_name.toLowerCase(), regex: '\\s+', str: '-');
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

  Future<void> create() async {
    final SiteListController ctrl = Get.put(SiteListController());
    isLoading = true;
    final String id = await addSite();

    // get site data
    // ntl api getSite --data '{ "site_id": "123456"}'
    // d40fc58f-f6a4-4a69-80d5-4b59b3fe5bdb

    final site = Site(
        name: local_name,
        path: path,
        linked: true,
        details: SiteDetails(
          account_slug: '',
          default_domain: '',
          id: '',
          name: '',
        ));
    // run script hre
    ctrl.sites.value.add(site);
    ctrl.sites.refresh();
    isLoading = false;
  }

  Future<String> addSite() async {
    final NetlifyCreateSite netlify = NetlifyCreateSite(name: local_name);
    final String response = await netlify() as String;
    return response;
  }
}
