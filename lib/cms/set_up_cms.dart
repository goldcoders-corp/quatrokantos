// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/download_zip.dart';
import 'package:quatrokantos/helpers/path_helper.dart';
import 'package:quatrokantos/helpers/unzip_files.dart';

class SetUpCMS {
  SetUpCMS({
    required this.themeURL,
    required this.cmsURL,
    required this.name,
    required this.folderName,
  });
  final String themeURL;
  final String cmsURL;
  final String name;
  final String folderName;

  Future<void> init() async {
    final theme = Downloader(
      url: themeURL,
      dir: PathHelper.getThemeDir,
      name: '$name.zip',
    );
    await theme.download((_) {
      if (kDebugMode) {
        print('done downloading theme');
      }
    });
    final cms =
        Downloader(url: cmsURL, dir: PathHelper.getCMSDIR, name: '$name.zip');
    await cms.download((_) {
      if (kDebugMode) {
        print('done downloading cms');
      }
    });

    final themeZip = p.join(PathHelper.getThemeDir, '$name.zip');
    final cmZip = p.join(PathHelper.getCMSDIR, '$name.zip');
    final cmsPath = p.join(PathHelper.getSitesDIR, folderName, 'cms');
    final themePath = p.join(PathHelper.getSitesDIR, folderName);

    final themeSetUp = UnzipFile(themeZip, themePath);
    final cmsSetUp = UnzipFile(cmZip, cmsPath);

    await themeSetUp.unzip((_) {
      if (kDebugMode) {
        print('Done Extracting Theme');
      }
    });

    await cmsSetUp.unzip((_) {
      if (kDebugMode) {
        print('Done Extracting CMS');
      }
    });
  }
}
