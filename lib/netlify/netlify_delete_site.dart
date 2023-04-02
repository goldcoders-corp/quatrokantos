import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class NetlifyDeleteSite {
  NetlifyDeleteSite({required this.siteID}) : super() {
    args = <String>['sites:delete', '-f', siteID];
  }
  final String siteID;
  final String command = 'ntl';
  late List<String> args = <String>[];

  Future<String> delete() async {
    // ignore: todo
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final buffer = StringBuffer();

    final process = await Process.start(command, args);
    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }

    final exitCode = await process.exitCode;
    if (exitCode >= 1) {
      return 'Error: No site with id $siteID found';
    } else {
      return buffer.toString().strip();
    }
  }
}
