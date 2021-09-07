import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:quatrokantos/helpers/replace_helper.dart';

class NetlifyCreateSite {
  final String name;
  final String account_slug;
  late final String command1;
  late List<String> args1 = <String>[];

  NetlifyCreateSite({required this.name, this.account_slug = 'hugoforbes88'})
      : super() {
    command1 = 'netlify';
    args1 = <String>['sites:create', '--name', name, '-a', account_slug];
  }

  Future<dynamic> call() async {
    final String random = RandomString(len: 4)();

    final String slug =
        ReplaceHelper(text: '$name-$random', str: '-').replace();
    String? output;

    final RegExp regExp = RegExp(r'[\w]{8}(-[\w]{4}){3}-[\w]{12}');

    final List<String> args = <String>[];
    args.add('sites:create');
    args.add('--name');
    args.add(slug);
    args.add('-a');
    args.add(account_slug);
    final Process process = await Process.start('netlify', args);
    final dynamic lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());

    await for (final String line in lineStream) {
      output = line;
    }
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
  final int len;

  RandomString({required this.len});
  String call() {
    final Random random = Random.secure();
    // ignore: lines_longer_than_80_chars
    final List<int> values =
        List<int>.generate(len, (int i) => random.nextInt(255));
    return base64UrlEncode(values);
  }
}
