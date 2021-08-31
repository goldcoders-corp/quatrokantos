import 'dart:io';

class WritterHelper {
  static Future<void> log(
      {required String filePath,
      required String e,
      required String stacktrace}) async {
    final File file = await File(filePath).create(recursive: true);
    final DateTime now = DateTime.now();
    final String timestamp =
        // ignore: lines_longer_than_80_chars
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    file.writeAsStringSync('$timestamp: $e\n $stacktrace\n',
        mode: FileMode.writeOnlyAppend);
  }
}
