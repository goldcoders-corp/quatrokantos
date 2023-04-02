// ignore_for_file: depend_on_referenced_packages, avoid_slow_async_io, avoid_dynamic_calls, lines_longer_than_80_chars

import 'dart:convert';
import 'dart:io';

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
    super.onInit();
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
    final themeStr = json.encode(val);
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
    var folder = dotenv.env['APP_NAME']!.toLowerCase();

    final text = ReplaceHelper(text: folder, regex: r'\s+');
    folder = text.replace();
    const filename = 'debug_download.txt';
    final filePath =
        p.join(PC.userDirectory, '.local', 'share', '.$folder', filename);
    // END ADDED FOR DEBUGGING
    isLoading = true;
    final zipName = '${file.name}.zip';
    final cmZip = p.join(
      PathHelper.getCMSDIR,
      zipName,
    );
    // ADDED FOR DEBUGGING
    await WritterHelper.log(
      filePath: filePath,
      stacktrace: 'zipName: $zipName',
    );
    // ADDED FOR DEBUGGING
    await WritterHelper.log(filePath: filePath, stacktrace: 'cmsZip: $cmZip');

    final themeZip = p.join(
      PathHelper.getThemeDir,
      zipName,
    );

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
      filePath: filePath,
      stacktrace: 'themeZip: $themeZip',
    );

    var cmsDownloaded = await File(cmZip).exists();
    var themeDownloaded = await File(themeZip).exists();

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
      filePath: filePath,
      stacktrace: 'cms downloaded: $cmsDownloaded',
    );

    // ADDED FOR DEBUGGING
    await WritterHelper.log(
      filePath: filePath,
      stacktrace: 'theme downloaded: $themeDownloaded',
    );

    if (themeDownloaded == false) {
      // ADDED FOR DEBUGGING
      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
downloading theme: ${file.name}
themeURL: ${file.themeUrl}
dir: ${PathHelper.getThemeDir}
name: $zipName
          ''',
      );

      final theme = Downloader(
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
              .trim(),
        );
      });
    }

    if (cmsDownloaded == false) {
      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
downloading cms: themeURL:
${file.cmsUrl}
dir: ${PathHelper.getCMSDIR}
name: $zipName
          ''',
      );
      final cms = Downloader(
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
              .trim(),
        );
      });
    }

    // where are check here if we already have the files

    final currentCMSPATH = p.join(
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
          .trim(),
    );

    final currentTHEMEPATH = p.join(
      PathHelper.getSitesDIR,
      projectName,
      'yarn.lock',
    );

    await WritterHelper.log(
      filePath: filePath,
      stacktrace: '''
currentTHEMEPATH: $currentTHEMEPATH
          '''
          .trim(),
    );

    var cmsInstalled = await File(currentCMSPATH).exists();
    var themeInstalled = await File(currentTHEMEPATH).exists();
    await WritterHelper.log(
      filePath: filePath,
      stacktrace: '''
cmsInstalled: $cmsInstalled
themeInstalled: $themeInstalled
          '''
          .trim(),
    );
    if (cmsInstalled == false) {
      final cmsPath = p.join(PathHelper.getSitesDIR, projectName, 'cms');
      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
cmsPath: $cmsPath
          '''
            .trim(),
      );
      final cmsSetUp = UnzipFile(cmZip, cmsPath);

      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
cmsSetup: $cmsSetUp
          '''
            .trim(),
      );
      await cmsSetUp.unzip((bool unzip) async {
        cmsInstalled = true;
      });
    }

    if (themeInstalled == false) {
      final themePath = p.join(PathHelper.getSitesDIR, projectName);
      final themeSetUp = UnzipFile(themeZip, themePath);

      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
themePath: $themePath
themeSetUp: $themeSetUp
          '''
            .trim(),
      );

      await themeSetUp.unzip((bool unzip) async {
        themeInstalled = true;
      });
    }
    if (themeInstalled && cmsInstalled) {
      project.themeInstalled = true;
      await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
project.themeInstalled: ${project.themeInstalled}
          '''
            .trim(),
      );
    }

    isLoading = false;
  }

  void loadDefaultThemes() {
    // This should be fetch on using supabase
    const thriftshop = Cms(
      name: 'thriftshop.site',
      cmsUrl: 'https://github.com/thriftapps/cms/archive/refs/heads/main.zip',
      themeUrl:
          'https://github.com/goldcoders/paramountpetroleum.ph/archive/refs/heads/main.zip',
    );

    // const Cms pitlords = Cms(
    //   name: 'pitlords.com',
    //   cmsUrl: 'https://github.com/thriftapps/cms/archive/refs/heads/main.zip',
    //   themeUrl: 'https://github.com/pitlords/site/archive/refs/heads/main.zip',
    // );
    _themes.value.add(thriftshop);
    // _themes.value.add(pitlords);
    list = list;
  }

  void generateThemesList() {
    final tokens = <String>[];
    for (var i = 0; i < list.length; i++) {
      tokens.add(list[i].name);
    }
    themeNames = tokens;
  }

  void initThemes() {
    final themeList = <Cms>[];
    if (_getStorage.hasData(CMS_LIST)) {
      final transformList =
          json.decode(_getStorage.read(SITE_LIST) as String) as List<dynamic>;
      for (final dynamic element in transformList) {
        final entryCms = Cms(
          name: element['name'] as String,
          cmsUrl: element['cmsUrl'] as String,
          themeUrl: element['themeUrl'] as String,
        );
        themeList.add(entryCms);
      }
      list = themeList;
    }
  }
}
