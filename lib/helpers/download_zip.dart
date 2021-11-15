import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/path_helper.dart';

class Downloader {
  final String url;
  final String dir;
  final String name;

  Downloader({
    required this.url,
    required this.dir,
    required this.name,
  });

  /// Example Usage:
  /// ```
  /// const String cmsURL =
  ///       'https://github.com/thriftapps/cms/archive/ce25c8fca76d999c22c3a6e2f3670abf0da3240f.zip';
  ///   const String themeURL =
  ///       'https://github.com/thriftapps/netlify/archive/refs/heads/main.zip';
  ///   const String cmsName = 'cms.zip';
  ///   const String themeName = 'thriftshop.zip';
  ///   final String path =
  ///       p.join(PC.userDirectory, '.local', 'share', 'quatrokantos');
  ///   const String filename = 'goldcoders.zip';
  ///   final DownloadZip dl =
  ///       DownloadZip(url: themeURL, path: path, filename: themeName);
  ///   await dl.download();
  /// ```
  Future<void> download(
    Function(bool done) onDone,
  ) async {
    final HttpClientRequest request = await HttpClient().getUrl(Uri.parse(url));
    final HttpClientResponse response = await request.close();
    final Uint8List bytes = await consolidateHttpClientResponseBytes(response);
    // This Ensures The Directory Exists
    PathHelper.mkd(dir);

    final File file = File('$dir/$name');
    await file.writeAsBytes(bytes);
    onDone(true);
  }

// error here empty cms zip
  static Future<void> defaultTheme(
      {required Function(bool downloaded) onDone}) async {
    bool installedCMS = false;
    bool installedTheme = false;

    final String zipName = dotenv.env['DEFAULT_SITE_THEME']!;
    final String cmZip = p.join(
      PathHelper.getCMSDIR,
      '$zipName.zip',
    );

    final String themeZip = p.join(
      PathHelper.getThemeDir,
      '$zipName.zip',
    );

    final bool cmsDownloaded = await File(cmZip).exists();
    final bool themeDownloaded = await File(themeZip).exists();

    if (themeDownloaded == false) {
      final Downloader theme = Downloader(
        url: dotenv.env['DEFAULT_SITE_THEME_URL']!,
        dir: PathHelper.getThemeDir,
        name: zipName,
      );
      await theme.download((_) {
        installedTheme = true;
      });
    }

    if (cmsDownloaded == false) {
      final Downloader cms = Downloader(
        url: dotenv.env['DEFAULT_SITE_CMS_URL']!,
        dir: PathHelper.getCMSDIR,
        name: zipName,
      );
      await cms.download((_) {
        installedCMS = true;
      });
    }
    onDone(installedCMS && installedTheme);
  }
}
