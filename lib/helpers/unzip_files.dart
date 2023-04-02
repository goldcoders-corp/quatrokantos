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
  // project folder name

  UnzipFile(
    this.path,
    this.destination,
  );
  final String path;
  final String destination;

  // ignore: inference_failure_on_function_return_type
  Future<void> unzip(Function(bool done) onDone) async {
    // ignore: todo
    //! TODO: add try catch since we are having error here
    //! if the url i add is private
    //! Also when we delete our site folder
    //! we need to catch it and remove our site from UI
    //FileSystemException
    final archive = ZipDecoder().decodeBytes(File(path).readAsBytesSync());

    for (final file in archive) {
      var filename = file.name;
      final regExp = RegExp(r'\/(.*)');
      filename = regExp.stringMatch(filename)!;

      if (file.isFile) {
        final data = file.content as List<int>;
        File(destination + filename)
          ..createSync(recursive: true)
          ..writeAsBytesSync(data);
      } else {
        await Directory(destination + filename).create(recursive: true);
      }
    }
    onDone(true);
  }
}
