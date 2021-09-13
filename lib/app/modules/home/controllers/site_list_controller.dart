import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/constants/site_constants.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/folder_launcher.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/netlify/netlify_api.dart';
import 'package:quatrokantos/netlify/netlify_delete_all_site.dart';

class SiteListController extends GetxController {
  final GetStorage _getStorage = GetStorage();
  final CommandController ctrl = Get.find<CommandController>();

  final Rx<List<Site>> sites = Rx<List<Site>>(<Site>[]);

  final RxBool _isLoading = false.obs;

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  @override
  // ignore: avoid_void_async
  void onInit() {
    getLocalData();
    super.onInit();
  }

  @override
  void onClose() {}

  Function listEquals = const DeepCollectionEquality().equals;
  Future<void> fetchSites() async {
    const String command = 'netlify';
    final List<String> args = <String>['sites:list', '--json'];
    final List<Site> siteList = <Site>[];

    ctrl.isLoading = true;

    final Cmd cmd = Cmd(command: command, args: args);
    await cmd.execute(onResult: (String output) {
      if (output.isNotEmpty) {
        final List<dynamic> transformSiteList =
            json.decode(output) as List<dynamic>;

        // ignore: avoid_function_literals_in_foreach_calls
        transformSiteList.forEach((dynamic element) {
          final Site entrySite = Site(
            name: element['name'] as String,
            linked: false,
            path: Folder(name: element['name'] as String).folder(),
            details: SiteDetails(
              // TODO: This is throwing an error at this LINE
              id: element['details']['id'] as String,
              name: element['details']['name'] as String,
              account_slug: element['details']['account_slug'] as String,
              default_domain: element['details']['default_domain'] as String,
              repo_url: element['details']?['repo_url'] as String?,
              custom_domain: element['details']?['custom_domain'] as String?,
            ),
          );
          siteList.add(entrySite);
        });
        //  If there is changes in Offline vs Remote Data
        if (listEquals(sites.value, siteList) == false) {
          // We Update The Sites Value
          sites.value = siteList;
          sites.refresh();
          final String siteData = json.encode(sites.value);
          saveLocal(siteData);
        }
      } else {
        sites.value = <Site>[];
        final String siteData = json.encode(sites.value);
        saveLocal(siteData);
      }
      ctrl.isLoading = false;
    });
  }

  Site? findByName(String name) =>
      sites.value.firstWhereOrNull((Site site) => site.name == name);

  Site? findById(String id) =>
      sites.value.firstWhereOrNull((Site site) => site.details?.id == id);

  int getIndex(String id) =>
      sites.value.indexWhere((Site site) => site.details?.id == id);

  Future<void> deleteSite(String id) async {
    isLoading = true;
    await NetlifyApi.deleteSite(id, onDone: (String? message) {
      Get.snackbar(
        'Site Deleted',
        'Site with id: $id Deleted Successfully',
        snackPosition: SnackPosition.BOTTOM,
        dismissDirection: SnackDismissDirection.HORIZONTAL,
      );
      final int index = getIndex(id);
      sites.value.removeAt(index);
      final String siteData = json.encode(sites.value);
      saveLocal(siteData);
      sites.refresh();
      isLoading = false;
    });
  }

  Future<void> deleteAllRemote() async {
    isLoading = true;
    final List<Site> siteList = <Site>[];
    sites.value = siteList;
    final NetlifyDeleteAllSites delete = NetlifyDeleteAllSites();
    await delete.all();
    await Directory(PathHelper.getSitesDIR).delete(recursive: true);
    isLoading = false;
  }

  /// Deliberately Delete All Local Data and Contents from sites folder
  /// and Delte All Site Remotely
  Future<void> uninstallSites() async {
    isLoading = true;
    final Directory sitesFolder = Directory(PathHelper.getSitesDIR);
    sitesFolder.exists().then((bool exists) {
      if (exists) {
        sitesFolder.delete(recursive: true);
      }
    });
    await emptyLocalSites();
    isLoading = false;
  }

  Future<void> emptyLocalSites() async {
    sites.value.toList().forEach((Site site) async {
      await deleteSite(site.details!.id);
    });
  }

  void getLocalData() {
    final List<Site> siteList = <Site>[];

    if (_getStorage.hasData(SITE_LIST)) {
      final List<dynamic> transformSiteList =
          json.decode(_getStorage.read(SITE_LIST) as String) as List<dynamic>;

      // ignore: avoid_function_literals_in_foreach_calls
      transformSiteList.forEach((dynamic element) {
        final Site entrySite = Site(
          name: element['name'] as String,
          path: element['path'] as String,
          linked: element['linked'] as bool,
          details: SiteDetails(
            id: element['details']['id'] as String,
            account_slug: element['details']['account_slug'] as String,
            default_domain: element['details']['default_domain'] as String,
            name: element['details']['name'] as String,
            repo_url: element['details']?['repo_url'] as String?,
            custom_domain: element['details']?['custom_domain'] as String?,
          ),
        );
        //list.addIf(entrySite < limit, item);
        siteList.add(entrySite);
      });
      sites.value = siteList;
      sites.refresh();
    }
  }

  /// Only JSON String here must be Stored
  void saveLocal(String sites) {
    _getStorage.write(SITE_LIST, sites);
  }
}
