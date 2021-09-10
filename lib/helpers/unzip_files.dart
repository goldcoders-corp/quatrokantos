import 'dart:io';

import 'package:archive/archive.dart';

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
    final Archive archive =
        ZipDecoder().decodeBytes(File(path).readAsBytesSync());
    for (final ArchiveFile file in archive) {
      String filename = file.name;
      final RegExp regExp = RegExp(r'\/(.*)');
      filename = regExp.stringMatch(filename)!;
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
