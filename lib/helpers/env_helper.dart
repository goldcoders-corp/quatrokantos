import 'dart:convert';
import 'dart:io';

import 'package:path/path.dart' as p;
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

  // check if we have .env.example on the current directory
  // if we have copy the it to .env
  // if we dont have .env.example check for other .env files
  // if we dont have any .env create a new .env with the default values
  static Future<void> copyOrCreateDotEnv(String folderPath) async {
    Directory.current = folderPath;
    final String dotenvPath = p.join(folderPath, '.env.example');

    final File dotEnvExample = File(dotenvPath);
    dotEnvExample.exists().then((bool exists) async {
      if (exists) {
        dotEnvExample.copy('.env');
      } else {
        const String defaultValue = '''
HUGO_BASEURL=https://thriftshop.site
SNOWPACK_PUBLIC_BACKEND_TYPE=git-gateway
SNOWPACK_PUBLIC_BRANCH=main
SNOWPACK_PUBLIC_BACKEND=true
SNOWPACK_PUBLIC_SHOW_PREVIEW_LINKS=true
SNOWPACK_PUBLIC_MEDIA_FOLDER=static/images
SNOWPACK_PUBLIC_DOMAIN=thriftshop.site
SNOWPACK_PUBLIC_DISPLAY_URL=https://thriftshop.site
SNOWPACK_PUBLIC_LOGO_URL=/images/logo.svg
SNOWPACK_PUBLIC_PUBLIC_FOLDER=/images
''';
        final String newDotEnv = p.join(folderPath, '.env');

        await File(newDotEnv).writeAsString(defaultValue);
      }
    });
  }
}
