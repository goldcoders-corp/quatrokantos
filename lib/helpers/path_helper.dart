import 'dart:io';

class PathHelper {
  /// #### Accept `List` of String or an `Empty List` and a `Fallback Path`
  /// #### Resolves The Path it found
  /// #### Returns the `Correct Path` it Resolves
  /// #### `Used` `Before Executing Any Commands`
  static Future<String> resolve(
      {required List<String> paths, required String fallback}) async {
    final StringBuffer pathBuffer = StringBuffer();

    for (final String element in paths) {
      if (await exists(element) == true) {
        pathBuffer.write(element);
        break;
      }
    }
    String path = pathBuffer.toString().trim();
    if (path.isEmpty) {
      path = fallback;
    }
    return path;
  }

  static Future<String?> existInPATH(
      {required String command,
      required List<String> paths,
      required String fallback}) async {
    final StringBuffer pathBuffer = StringBuffer();

    for (final String element in paths) {
      final String cmd = '$element/$command';
      final bool installed = await File(cmd).exists();
      if (installed == true) {
        pathBuffer.write(element);
        break;
      }
    }
    final String path = pathBuffer.toString().trim();
    if (path.isEmpty) {
      final String cmd = '$fallback/$command';
      final bool installed = await File(cmd).exists();
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
    return FileSystemEntity.isDirectory(path);
  }
}
