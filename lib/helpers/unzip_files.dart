import 'dart:io';

import 'package:archive/archive.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';
import 'package:quatrokantos/helpers/replace_helper.dart';
import 'package:quatrokantos/helpers/writter_helper.dart';
import 'package:path/path.dart' as p;

/// Example Usage:
/// ```
/// final String zipPath = p.join(
///      PC.userDirectory, '.local', 'share', 'quatrokantos', 'goldcoders.zip');
///   final String cmsPath =
///      p.join(PC.userDirectory, '.local', 'share', 'quatrokantos', 'cms.zip');
///   final String destination = p.join(PC.userDirectory, '.local', 'share',
///       '.thriftshop_desktop_site_manager', 'sites', 'kingkongpower');
///   final String cmsLoc = p.join(PC.userDirectory, '.local', 'share',
///       '.thriftshop_desktop_site_manager', 'sites', 'kingkongpower', 'cms');
///
///   final UnzipFile theme = UnzipFile(
///     zipPath,
///     destination,
///   );
///   await theme.unzip();
///   final UnzipFile cms = UnzipFile(
///     cmsPath,
///     cmsLoc,
///   );
///   await cms.unzip((onDone){});
/// ```
class UnzipFile {
  final String path;
  final String destination; // project folder name

  UnzipFile(
    this.path,
    this.destination,
  );

  Future<void> unzip(Function(bool done) onDone) async {
    // ADDED FOR DEBUGGING
    String folder = dotenv.env['APP_NAME']!.toLowerCase();

    final ReplaceHelper text = ReplaceHelper(text: folder, regex: '\\s+');
    folder = text.replace();
    const String filename = 'debug_download.txt';
    final String filePath =
        p.join(PC.userDirectory, '.local', 'share', '.$folder', filename);
    // END ADDED FOR DEBUGGING
    await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
Inside unzip function
path: $path
destination: $destination
          '''
            .trim());
    final Archive archive =
        ZipDecoder().decodeBytes(File(path).readAsBytesSync());
    await WritterHelper.log(
        filePath: filePath,
        stacktrace: '''
Archive ${archive.toString()}
          '''
            .trim());
    for (final ArchiveFile file in archive) {
      String filename = file.name;
      // possible we are stuck here
      final RegExp regExp = RegExp(r'\/(.*)');
      filename = regExp.stringMatch(filename)!;
      await WritterHelper.log(
          filePath: filePath,
          stacktrace: '''
filename String Match: $filename
          '''
              .trim());
      if (file.isFile) {
        final List<int> data = file.content as List<int>;
        File(destination + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        Directory(destination + filename).create(recursive: true);
      }
    }
    onDone(true);
  }
}
