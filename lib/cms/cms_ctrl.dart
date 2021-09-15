import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/app/modules/project/controllers/project_controller.dart';
import 'package:quatrokantos/cms/cms_model.dart';
import 'package:quatrokantos/constants/site_constants.dart';
import 'package:quatrokantos/helpers/download_zip.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';
import 'package:quatrokantos/helpers/unzip_files.dart';
import 'package:quatrokantos/helpers/writter_helper.dart';

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

  Cms? get getChoosen =>
      list.firstWhereOrNull((Cms cms) => cms.name == currentTheme);

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
    // ADDED FOR DEBUGGING
    String folder = dotenv.env['APP_NAME']!.toLowerCase();

    final ReplaceHelper text = ReplaceHelper(text: folder, regex: '\\s+');
    folder = text.replace();
    const String filename = 'debug_download.txt';
    final String filePath =
        p.join(PC.userDirectory, '.local', 'share', '.$folder', filename);
    // END ADDED FOR DEBUGGING
    isLoading = true;
    final String zipName = '${file.name}.zip';
    final String cmZip = p.join(
      PathHelper.getCMSDIR,
      zipName,
    );
    // ADDED FOR DEBUGGING
    await WritterHelper.log(
        filePath: filePath, stacktrace: 'zipName: $zipName');
    // ADDED FOR DEBUGGING
    await WritterHelper.log(filePath: filePath, stacktrace: 'cmsZip: $cmZip');

    final String themeZip = p.join(
      PathHelper.getThemeDir,
      zipName,
    );

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
        filePath: filePath, stacktrace: 'themeZip: $themeZip');

    bool cmsDownloaded = await File(cmZip).exists();
    bool themeDownloaded = await File(themeZip).exists();

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
        filePath: filePath, stacktrace: 'cms downloaded: $cmsDownloaded');

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
        filePath: filePath, stacktrace: 'theme downloaded: $themeDownloaded');

    if (themeDownloaded == false) {
      // ADDED FOR DEBUGGING
      await WritterHelper.log(filePath: filePath, stacktrace: '''
downloading theme: themeURL:
${file.themeUrl}
dir: ${PathHelper.getThemeDir}
name: $zipName
          ''');

      final Downloader theme = Downloader(
        url: file.themeUrl,
        dir: PathHelper.getThemeDir,
        name: zipName,
      );
      await theme.download((_) async {
        themeDownloaded = true;
        // ADDED FOR DEBUGGING
        await WritterHelper.log(
            filePath: filePath,
            stacktrace: '''
          themeDownloaded: $themeDownloaded
          '''
                .trim());
      });
    }

    if (cmsDownloaded == false) {
      await WritterHelper.log(filePath: filePath, stacktrace: '''
downloading cms: themeURL:
${file.themeUrl}
dir: ${PathHelper.getThemeDir}
name: $zipName
          ''');
      final Downloader cms = Downloader(
        url: file.cmsUrl,
        dir: PathHelper.getCMSDIR,
        name: zipName,
      );
      await cms.download((_) async {
        cmsDownloaded = true;
        // ADDED FOR DEBUGGING
        await WritterHelper.log(
            filePath: filePath,
            stacktrace: '''
          themeDownloaded: $themeDownloaded
          '''
                .trim());
      });
    }

    // where are check here if we already have the files

    final String currentCMSPATH = p.join(
      PathHelper.getSitesDIR,
      projectName,
      'cms',
      'yarn.lock',
    );
    await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
currentCMSPATH: $currentCMSPATH
          '''
            .trim());

    final String currentTHEMEPATH = p.join(
      PathHelper.getSitesDIR,
      projectName,
      'yarn.lock',
    );

    await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
currentTHEMEPATH: $currentTHEMEPATH
          '''
            .trim());

    bool cmsInstalled = await File(currentCMSPATH).exists();
    bool themeInstalled = await File(currentTHEMEPATH).exists();
    await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
cmsInstalled: $cmsInstalled
themeInstalled: $themeInstalled
          '''
            .trim());
    if (cmsInstalled == false) {
      final String cmsPath = p.join(PathHelper.getSitesDIR, projectName, 'cms');
      await WritterHelper.log(
          filePath: filePath,
          stacktrace: '''
cmsPath: $cmsPath
          '''
              .trim());
      final UnzipFile cmsSetUp = UnzipFile(cmZip, cmsPath);

      await WritterHelper.log(
          filePath: filePath,
          stacktrace: '''
cmsSetup: $cmsSetUp
          '''
              .trim());
      await cmsSetUp.unzip((bool unzip) async {
        await WritterHelper.log(
            filePath: filePath,
            stacktrace: '''
unzip: $unzip
          '''
                .trim());
        Get.snackbar('CMS Installed', 'Start Running CMS',
            dismissDirection: SnackDismissDirection.HORIZONTAL);
      });
    }

    if (themeInstalled == false) {
      final String themePath = p.join(PathHelper.getSitesDIR, projectName);
      final UnzipFile themeSetUp = UnzipFile(themeZip, themePath);

      await WritterHelper.log(
          filePath: filePath,
          stacktrace: '''
themePath: $themePath
themeSetUp: $themeSetUp
          '''
              .trim());

      await themeSetUp.unzip((bool unzip) async {
        await WritterHelper.log(
            filePath: filePath,
            stacktrace: '''
unzip: $unzip
          '''
                .trim());
      });
    }
    if (themeInstalled && cmsInstalled) {
      project.themeInstalled = true;
      await WritterHelper.log(
          filePath: filePath,
          stacktrace: '''
project.themeInstalled: ${project.themeInstalled}
          '''
              .trim());
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
