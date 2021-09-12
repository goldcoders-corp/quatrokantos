import 'dart:io';

class WritterHelper {
  static Future<void> log(
      {required String filePath, String? e, required String stacktrace}) async {
    final File file = await File(filePath).create(recursive: true);
    final DateTime now = DateTime.now();
    final String timestamp =
        // ignore: lines_longer_than_80_chars
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    final StringBuffer outputbuffer = StringBuffer();
    if (e != null) {
      outputbuffer.write('$timestamp: $e \n');
    }
    outputbuffer.write('$stacktrace \n');
    file.writeAsStringSync(outputbuffer.toString(),
        mode: FileMode.writeOnlyAppend);
  }
}
