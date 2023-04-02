import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:quatrokantos/helpers/replace_helper.dart';

class NetlifyCreateSite {
  NetlifyCreateSite({required this.name, this.accountSlug = 'hugoforbes88'})
      : super() {
    command1 = 'netlify';
    args1 = <String>['sites:create', '--name', name, '-a', accountSlug];
  }
  final String name;
  final String accountSlug;
  late final String command1;
  late List<String> args1 = <String>[];

  Future<dynamic> call() async {
    final random = RandomString(len: 4)();

    final slug = ReplaceHelper(text: '$name-$random', str: '-').replace();
    String? output;

    final regExp = RegExp(r'[\w]{8}(-[\w]{4}){3}-[\w]{12}');

    final args = <String>['sites:create', '--name', slug, '-a', accountSlug];

    final process = await Process.start('netlify', args);
    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    await for (final String line in lineStream) {
      output = line;
    }
    // ignore: inference_failure_on_function_invocation
    await process.stderr.drain();
    if (await process.exitCode == 1) {
      output = 'Error: $output';
    } else {
      output = regExp.stringMatch(output!).toString();
    }
    return output;
  }
}

class RandomString {
  RandomString({required this.len});
  final int len;
  String call() {
    final random = Random.secure();
    // ignore: lines_longer_than_80_chars
    final values = List<int>.generate(len, (int i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
