// ignore_for_file: depend_on_referenced_packages, avoid_slow_async_io

import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/path_helper.dart';

class Downloader {
  Downloader({
    required this.url,
    required this.dir,
    required this.name,
  });
  final String url;
  final String dir;
  final String name;

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
    // ignore: inference_failure_on_function_return_type
    Function(bool done) onDone,
  ) async {
    final request = await HttpClient().getUrl(Uri.parse(url));
    final response = await request.close();
    final bytes = await consolidateHttpClientResponseBytes(response);
    // This Ensures The Directory Exists
    PathHelper.mkd(dir);

    final file = File('$dir/$name');
    await file.writeAsBytes(bytes);
    onDone(true);
  }

// error here empty cms zip
  static Future<void> defaultTheme({
    // ignore: inference_failure_on_function_return_type
    required Function(bool downloaded) onDone,
  }) async {
    var installedCMS = false;
    var installedTheme = false;

    final zipName = dotenv.env['DEFAULT_SITE_THEME']!;
    final cmZip = p.join(
      PathHelper.getCMSDIR,
      '$zipName.zip',
    );

    final themeZip = p.join(
      PathHelper.getThemeDir,
      '$zipName.zip',
    );

    final cmsDownloaded = await File(cmZip).exists();
    final themeDownloaded = await File(themeZip).exists();

    if (themeDownloaded == false) {
      final theme = Downloader(
        url: dotenv.env['DEFAULT_SITE_THEME_URL']!,
        dir: PathHelper.getThemeDir,
        name: zipName,
      );
      await theme.download((_) {
        installedTheme = true;
      });
    }

    if (cmsDownloaded == false) {
      final cms = Downloader(
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
