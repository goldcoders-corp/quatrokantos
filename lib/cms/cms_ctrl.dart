import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/cms/cms_model.dart';
import 'package:quatrokantos/constants/site_constants.dart';
import 'package:quatrokantos/helpers/download_zip.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/unzip_files.dart';

class CmsController extends GetxController {
  final GetStorage _getStorage = GetStorage();

  final RxBool _isLoading = false.obs;
  final Rx<Cms> _cms = const Cms(cmsUrl: '', name: '', themeUrl: '').obs;
  final Rx<List<Cms>> _themes = Rx<List<Cms>>(<Cms>[]);
  final Rx<List<String>> _themeNames = Rx<List<String>>(<String>[]);
  final RxString _currentTheme = ''.obs;
  final ProjectController project = Get.put(ProjectController());

  @override
  void onInit() {
    loadDefaultThemes();
    generateThemesList();
  }

  String get currentTheme => _currentTheme.value;
  set currentTheme(String val) => _currentTheme.value = val;

  List<String> get themeNames => _themeNames.value;
  set themeNames(List<String> val) => _themeNames.value = val;

  bool get isLoading => _isLoading.value;
  set isLoading(bool val) => _isLoading.value = val;

  Cms get entry => _cms.value;
  set entry(Cms val) => _cms.value = val;

  List<Cms> get list => _themes.value;

  int getIndex(String name) => list.indexWhere((Cms cms) => cms.name == name);

  Cms? get getChoosen => list.firstWhere((Cms cms) => cms.name == currentTheme);

  set list(List<Cms> val) {
    _themes.value = val;
    final String themeStr = json.encode(val);
    saveThemes(themeStr);
    _themes.refresh();
  }

  void addTheme(Cms theme) {
    _themes.value.add(theme);
    list = list;
  }

  void saveThemes(String themes) {
    _getStorage.write(CMS_LIST, themes);
  }

  Future<void> download(String projectName, Cms file) async {
    isLoading = true;
    final String zipName = '${file.name}.zip';
    final String cmZip = p.join(
      PathHelper.getCMSDIR,
      zipName,
    );

    final String themeZip = p.join(
      PathHelper.getThemeDir,
      zipName,
    );

    final bool cmsDownloaded = await File(cmZip).exists();
    final bool themeDownloaded = await File(themeZip).exists();

    if (themeDownloaded == false) {
      final Downloader theme = Downloader(
        url: file.themeUrl,
        dir: PathHelper.getThemeDir,
        name: zipName,
      );
      await theme.download((_) {
        Get.snackbar('Theme Downloaded', 'It Will Be Cached For Later Use',
            dismissDirection: SnackDismissDirection.HORIZONTAL);
      });
    }

    if (cmsDownloaded == false) {
      final Downloader cms = Downloader(
        url: file.cmsUrl,
        dir: PathHelper.getCMSDIR,
        name: zipName,
      );
      await cms.download((_) {
        Get.snackbar('Cms Downloaded', 'It Will Be Cached For Later Use',
            dismissDirection: SnackDismissDirection.HORIZONTAL);
      });
    }

    final String currentCMSPATH = p.join(
      PathHelper.getSitesDIR,
      projectName,
      'cms',
      'package.json',
    );

    final String currentTHEMEPATH = p.join(
      PathHelper.getSitesDIR,
      projectName,
      'package.json',
    );
    final bool cmsInstalled = await File(currentCMSPATH).exists();
    final bool themeInstalled = await File(currentTHEMEPATH).exists();

    if (cmsInstalled == false) {
      final String cmsPath = p.join(PathHelper.getSitesDIR, projectName, 'cms');

      final UnzipFile cmsSetUp = UnzipFile(cmZip, cmsPath);

      await cmsSetUp.unzip((_) {
        Get.snackbar('CMS Installed', 'Start Running CMS',
            dismissDirection: SnackDismissDirection.HORIZONTAL);
      });
    } else {
      Get.snackbar('CMS Already Installed', 'Start Adding Stuff To Your Site',
          dismissDirection: SnackDismissDirection.HORIZONTAL);
    }

    if (themeInstalled == false) {
      final String themePath = p.join(PathHelper.getSitesDIR, projectName);
      final UnzipFile themeSetUp = UnzipFile(themeZip, themePath);

      await themeSetUp.unzip((_) {
        project.themeInstalled = true;
        Get.snackbar('Site Loaded', 'Start Customizing Your Site',
            dismissDirection: SnackDismissDirection.HORIZONTAL);
      });
    } else {
      project.themeInstalled = true;

      Get.snackbar('Site Already Installed', 'Start Building Your Site',
          dismissDirection: SnackDismissDirection.HORIZONTAL);
    }

    isLoading = false;
  }

  void loadDefaultThemes() {
    const Cms goldcoders = Cms(
      name: 'goldcoders.dev',
      cmsUrl: 'https://github.com/thriftapps/cms/archive/refs/heads/main.zip',
      themeUrl:
          'https://github.com/thriftapps/goldcoders.dev/archive/refs/heads/main.zip',
    );

    // const Cms pitlords = Cms(
    //   name: 'pitlords.com',
    //   cmsUrl: 'https://github.com/thriftapps/cms/archive/refs/heads/main.zip',
    //   themeUrl: 'https://github.com/pitlords/site/archive/refs/heads/main.zip',
    // );
    _themes.value.add(goldcoders);
    // _themes.value.add(pitlords);
    list = list;
  }

  void generateThemesList() {
    final List<String> tokens = <String>[];
    for (int i = 0; i < list.length; i++) {
      tokens.add(list[i].name);
    }
    themeNames = tokens;
  }

  void initThemes() {
    final List<Cms> themeList = <Cms>[];
    if (_getStorage.hasData(CMS_LIST)) {
      final List<dynamic> transformList =
          json.decode(_getStorage.read(SITE_LIST) as String) as List<dynamic>;
      transformList.forEach((dynamic element) {
        final Cms entryCms = Cms(
            name: element['name'] as String,
            cmsUrl: element['cmsUrl'] as String,
            themeUrl: element['themeUrl'] as String);
        themeList.add(entryCms);
      });
      list = themeList;
    }
  }
}
