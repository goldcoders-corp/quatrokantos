// ignore_for_file: depend_on_referenced_packages

import 'dart:io';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:path/path.dart' as p;
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';

class PathHelper {
  /// #### Accept `List` of String or an `Empty List` and a `Fallback Path`
  /// #### Resolves The Path it found
  /// #### Returns the `Correct Path` it Resolves
  /// #### `Used` `Before Executing Any Commands`
  static Future<String> resolve({
    required List<String> paths,
    required String fallback,
  }) async {
    final pathBuffer = StringBuffer();

    for (final element in paths) {
      if (await exists(element) == true) {
        pathBuffer.write(element);
        break;
      }
    }
    var path = pathBuffer.toString().trim();
    if (path.isEmpty) {
      path = fallback;
    }
    return path;
  }

  static Future<String?> existInPATH({
    required String command,
    required List<String> paths,
    required String fallback,
  }) async {
    final pathBuffer = StringBuffer();

    for (final element in paths) {
      final cmd = '$element/$command';
      // ignore: avoid_slow_async_io
      final installed = await File(cmd).exists();
      if (installed == true) {
        pathBuffer.write(element);
        break;
      }
    }
    final path = pathBuffer.toString().trim();
    if (path.isEmpty) {
      final cmd = '$fallback/$command';
      // ignore: avoid_slow_async_io
      final installed = await File(cmd).exists();
      if (installed == true) {
        return fallback;
      } else {
        return null;
      }
    }
    return path;
  }

  /// #### Fix Issue on Mac `File or Directory not found when executing CMD`
  /// - Change Directory, relative to the command
  /// - Before we Execute the command : ie:  `./brew --version`
  /// #### Throws an Exception on Debug and Build Release
  /// - `CommandFailedException` will be thrown and catch
  ///
  /// `DEBUG` must be set to `TRUE` on `.env`
  static void cd(String path) {
    Directory.current = Directory(path);
  }

  ///  Create Directory if it Doesnt Exists yet
  /// ```
  ///    final String folder = p.join(
  ///    PC.userDirectory, '.local', 'share', 'another', 'recursive', 'dir');
  ///    PathHelper.mkd(folder);
  ///    bool exists = await PathHelper.exists(folder);
  ///    assert(exists,true);
  /// ```
  static void mkd(String dir) {
    Directory(dir).createSync(recursive: true);
  }

  ///  #### Delete Directory
  ///  #### If `recursive` is set `true` , same as `rm -rf` in linux
  ///  #### that deletes the folder and all files and subfolder inside it
  /// ```
  ///    final String folder = p.join(
  ///    PC.userDirectory, '.local', 'share', 'another', 'recursive', 'dir');
  ///    PathHelper.delete(folder);
  ///    bool exists = await PathHelper.exists(folder);
  ///    assert(exists,false);
  /// ```
  static void delete(String dir, {bool recursive = false}) {
    Directory(dir).delete(recursive: recursive);
  }

  /// Check if a Given String Exist in the File System
  ///
  ///  Example Usage:
  ///
  ///     if (await exists(element) == true) {
  ///        pathBuffer.write(element);
  ///        break;
  ///      }
  ///
  static Future<bool> exists(String path) {
    // ignore: avoid_slow_async_io
    return FileSystemEntity.isDirectory(path);
  }

  static String get getThemeDir {
    var appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    // ignore: unnecessary_string_escapes
    final text = ReplaceHelper(text: appFolder, regex: r'\s+');
    appFolder = text.replace();
    return p.join(PC.userDirectory, '.local', 'share', '.$appFolder', 'themes');
  }

  static String get getCMSDIR {
    var appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    // ignore: unnecessary_string_escapes
    final text = ReplaceHelper(text: appFolder, regex: r'\s+');
    appFolder = text.replace();
    return p.join(PC.userDirectory, '.local', 'share', '.$appFolder', 'cms');
  }

  static String get getSitesDIR {
    var appFolder = dotenv.env['APP_NAME']!.toLowerCase();
    // ignore: unnecessary_string_escapes
    final text = ReplaceHelper(text: appFolder, regex: r'\s+');
    appFolder = text.replace();
    return p.join(PC.userDirectory, '.local', 'share', '.$appFolder', 'sites');
  }
}
