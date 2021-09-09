import 'dart:io';

class ReadAsString {
  /// Reads the contents of the file at `path` as a string.
  static String fromPath(String path) => File(path).readAsStringSync();
}
