import 'dart:convert';
import 'dart:io';

import 'package:quatrokantos/exceptions/command_failed_exception.dart';

class EnvHelper {
  late final String _path;

  EnvHelper({required String path}) : _path = path;

  String get path => _path;

  set path(String p) => _path = p;

  Future<Map<String, String>> read() async {
    final File file = File(path);

    final Map<String, String> source = <String, String>{};

    final Stream<String> lines =
        file.openRead().transform(utf8.decoder).transform(const LineSplitter());
    try {
      await for (final String line in lines) {
        if (line != '') {
          final List<String> newline = line.split('=');
          final List<String> entry = newline.toList();
          source[entry[0]] = entry[1];
        }
      }
    } catch (e, stacktrace) {
      CommandFailedException.log(
        e.toString(),
        stacktrace.toString(),
      );
    }
    return source;
  }

  Future<void> replace({
    required String key,
    required String value,
  }) async {
    final StringBuffer envBuffer = StringBuffer();
    final Map<String, String> envFile = await read();

    envFile.forEach((String oldKey, String oldVal) {
      if (oldKey == key) {
        envBuffer.write('$oldKey=$value\n');
      } else {
        envBuffer.write('$oldKey=$oldVal\n');
      }
    });
    envBuffer.toString();
    await File(path).writeAsString(envBuffer.toString());
  }

  /// #### The Value from invoking
  /// #### env.read()
  /// #### after we intantiate The EnvHelper Class
  /// #### Any Changes to the Map<String,String>
  /// #### From UI Will just be Passed here as the `contents`
  Future<void> write({required Map<String, String> contents}) async {
    final StringBuffer envBuffer = StringBuffer();

    contents.forEach((String key, String val) {
      envBuffer.write('$key=$val\n');
    });
    envBuffer.toString();
    await File(path).writeAsString(envBuffer.toString());
  }
}
