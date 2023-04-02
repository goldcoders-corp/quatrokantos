import 'dart:io';

class WritterHelper {
  static Future<void> log({
    required String filePath,
    required String stacktrace,
    String? e,
  }) async {
    final file = await File(filePath).create(recursive: true);
    final now = DateTime.now();
    final timestamp =
        // ignore: lines_longer_than_80_chars, noop_primitive_operations
        "${now.year.toString()}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')} ${now.hour.toString().padLeft(2, '0')}-${now.minute.toString().padLeft(2, '0')}";
    final outputbuffer = StringBuffer();
    if (e != null) {
      outputbuffer.write('$timestamp: $e \n');
    }
    outputbuffer.write('$stacktrace \n');
    file.writeAsStringSync(
      outputbuffer.toString(),
      mode: FileMode.writeOnlyAppend,
    );
  }
}
