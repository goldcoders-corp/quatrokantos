import 'dart:convert';
import 'dart:io';

import 'package:tint/tint.dart';

class NetlifyDeployDraft {
  final String command = 'ntl';
  final String path;
  late List<String> args = <String>[];
  NetlifyDeployDraft({required this.path}) : super() {
    Directory.current = Directory(path);
    args = <String>['deploy'];
  }

  Future<Map<String, String>> call() async {
    final StringBuffer buffer = StringBuffer();
    final RegExp jsonErrorRegExp =
        RegExp(r'\bWill\sproceed\swithout\sdeploying\b');
    final RegExp siteErrorRegExp =
        RegExp(r"\bThis\sfolder\sisn\'t\slinked\sto\sa\ssite\syet\b");
    final RegExp draftUrlRegExp = RegExp(r'(?<=URL:).*?\n');
    final RegExp logsRegExp = RegExp(r'(?<=Logs:).*?\n');

    final StringBuffer errorMessage = StringBuffer();

    final Process process = await Process.start(command, args);
    final Stream<String> lineStream = process.stdout
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
    final String error = errorMessage.toString().strip();
    final String output = buffer.toString().strip();
    if (error.isNotEmpty) {
      final Map<String, String> errorMap = <String, String>{
        'error': error,
      };
      return errorMap;
    } else if (output.isNotEmpty) {
      String? draft_url;
      String? log_url;
      if (draftUrlRegExp.hasMatch(output)) {
        draft_url = draftUrlRegExp.stringMatch(output).toString().strip();
      }
      if (logsRegExp.hasMatch(output)) {
        log_url = logsRegExp.stringMatch(output).toString().strip();
      }
      final Map<String, String> outputMap = <String, String>{
        'draft_url': draft_url ?? '',
        'log_url': log_url ?? '',
      };
      return outputMap;
    } else {
      final Map<String, String> errorMap = <String, String>{
        'error': 'Unexpected Error Happened On Deploy Process'
      };
      return errorMap;
    }
  }
}
