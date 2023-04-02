import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class NetlifyDeployDraft {
  NetlifyDeployDraft({required this.path}) : super() {
    Directory.current = Directory(path);
    args = <String>['deploy'];
  }
  final String command = 'ntl';
  final String path;
  late List<String> args = <String>[];

  Future<Map<String, String>> call() async {
    final buffer = StringBuffer();
    final jsonErrorRegExp = RegExp(r'\bWill\sproceed\swithout\sdeploying\b');
    final siteErrorRegExp =
        RegExp(r"\bThis\sfolder\sisn\'t\slinked\sto\sa\ssite\syet\b");
    final draftUrlRegExp = RegExp(r'(?<=URL:).*?\n');
    final logsRegExp = RegExp(r'(?<=Logs:).*?\n');

    final errorMessage = StringBuffer();

    final process = await Process.start(command, args);
    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      if (siteErrorRegExp.hasMatch(line)) {
        errorMessage.write("This folder isn't linked to a site yet");
        process.kill();
        break;
      } else if (jsonErrorRegExp.hasMatch(line)) {
        errorMessage.write('Try to Switch Netlify User Account for this Site');
        process.kill();
        break;
      } else {
        buffer.write('$line\n');
      }
    }
    final error = errorMessage.toString().strip();
    final output = buffer.toString().strip();
    if (error.isNotEmpty) {
      final errorMap = <String, String>{
        'error': error,
      };
      return errorMap;
    } else if (output.isNotEmpty) {
      String? draftUrl;
      String? logUrl;
      if (draftUrlRegExp.hasMatch(output)) {
        draftUrl = draftUrlRegExp.stringMatch(output).toString().strip();
      }
      if (logsRegExp.hasMatch(output)) {
        logUrl = logsRegExp.stringMatch(output).toString().strip();
      }
      final outputMap = <String, String>{
        'draft_url': draftUrl ?? '',
        'log_url': logUrl ?? '',
      };
      return outputMap;
    } else {
      final errorMap = <String, String>{
        'error': 'Unexpected Error Happened On Deploy Process'
      };
      return errorMap;
    }
  }
}
