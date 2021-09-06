import 'dart:convert';

import 'package:get/get.dart';
import 'package:quatrokantos/app/modules/home/views/models/site_model.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';

class HomeController extends GetxController {
  //TODO: Implement HomeController

  final Rx<List<Site>> sites = Rx<List<Site>>(<Site>[]);

  @override
  // ignore: avoid_void_async
  void onInit() async {
    await fetchSites();
    super.onInit();
  }

  @override
  void onClose() {}

  Future<void> fetchSites() async {
    final CommandController ctrl = Get.put(CommandController());
    const String command = 'netlify';
    final List<String> args = <String>['sites:list', '--json'];
    ctrl.isLoading = true;
    final Cmd cmd = Cmd(command: command, args: args);
    await cmd.execute(onResult: (String output) {
      final List<dynamic> fetchSites = json.decode(output) as List<dynamic>;

      fetchSites.forEach((dynamic element) {
        final String? cdomain = element['custom_domain'] as String?;

        final String ddomain = element['default_domain'] as String;

        final Site entrySite = Site(
          local_name: element['name'] as String? ?? '',
          custom_domain: cdomain,
          path: '',
          id: element['id'] as String,
          name: element['name'] as String,
          account_slug: element['account_slug'] as String,
          default_domain: ddomain,
          repo_url: element['build_settings']['repo_url'] as String?,
        );
        sites.value.add(entrySite);
      });
      sites.refresh();

      ctrl.isLoading = false;
    });
  }
}
