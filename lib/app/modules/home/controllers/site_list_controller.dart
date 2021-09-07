import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';

class SiteListController extends GetxController {
  final Rx<List<Site>> sites = Rx<List<Site>>(<Site>[]);

  @override
  // ignore: avoid_void_async
  void onInit() async {
    await fetchSites();
    super.onInit();
  }

  @override
  void onClose() {}

  Function listEquals = const DeepCollectionEquality().equals;

  Future<void> fetchSites() async {
    final CommandController ctrl = Get.put(CommandController());
    const String command = 'netlify';
    final List<String> args = <String>['sites:list', '--json'];
    final List<Site> siteList = <Site>[];

    ctrl.isLoading = true;

    final Cmd cmd = Cmd(command: command, args: args);
    await cmd.execute(onResult: (String output) {
      final List<dynamic> transformSiteList =
          json.decode(output) as List<dynamic>;

      // ignore: avoid_function_literals_in_foreach_calls
      transformSiteList.forEach((dynamic element) {
        final Site entrySite = Site(
          id: element['id'] as String,
          name: element['name'] as String,
          account_slug: element['account_slug'] as String,
          default_domain: element['default_domain'] as String,
          repo_url: element['build_settings']['repo_url'] as String?,
        );
        //list.addIf(entrySite < limit, item);
        siteList.add(entrySite);
        print(entrySite.toJson());
      });
      //  If there is changes in Offline vs Remote Data
      if (listEquals(sites.value, siteList) == false) {
        // We Update The Sites Value
        sites.value = siteList;
        sites.refresh();
      }

      ctrl.isLoading = false;
    });
  }
}
