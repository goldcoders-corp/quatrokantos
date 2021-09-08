import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class NetlifyDeleteSite {
  final String siteID;
  final String command = 'ntl';
  late List<String> args = <String>[];
  NetlifyDeleteSite({required this.siteID}) : super() {
    args = <String>['sites:delete', '-f', siteID];
  }

  Future<String> delete() async {
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final StringBuffer buffer = StringBuffer();

    final Process process = await Process.start(command, args);
    final Stream<String> lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }

    final int exitCode = await process.exitCode;
    if (exitCode >= 1) {
      return 'Error: No site with id $siteID found';
    } else {
      return buffer.toString().strip();
    }
  }
}
