import 'dart:convert';
import 'dart:io';

import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:tint/tint.dart';

class NetlifyDeploy {
  final String command = 'ntl';
  final String path;
  late List<String> args = <String>[];
  NetlifyDeploy({required this.path}) : super() {
    Directory.current = Directory(path);
    args = <String>['deploy', '--prod'];
  }

  Future<Map<String, String>> call() async {
    final StringBuffer buffer = StringBuffer();
    final RegExp jsonErrorRegExp =
        RegExp(r'\bWill\sproceed\swithout\sdeploying\b');
    final RegExp siteErrorRegExp =
        RegExp(r"\bThis\sfolder\sisn\'t\slinked\sto\sa\ssite\syet\b");
    final StringBuffer errorMessage = StringBuffer();

    final RegExp uniqueURLRegExp = RegExp(r'(?<=Unique Deploy URL:).*?\n');
    final RegExp logsRegExp = RegExp(r'(?<=Logs:).*?\n');
    final RegExp webURLRegExp = RegExp(r'(?<=Website URL:).*?\n');

    final Process process = await Process.start(command, args,
        runInShell: true,
        workingDirectory: path,
        environment: <String, String>{'PATH': PathEnv.get()});

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
    final String output = buffer.toString();
    if (error.isNotEmpty) {
      final Map<String, String> errorMap = <String, String>{
        'error': error,
      };
      return errorMap;
    } else if (output.isNotEmpty) {
      String? website_url;
      String? logs_url;
      String? unique_deploy_url;
      if (webURLRegExp.hasMatch(output)) {
        website_url = webURLRegExp.stringMatch(output).toString().strip();
      }
      if (logsRegExp.hasMatch(output)) {
        logs_url = logsRegExp.stringMatch(output).toString().strip();
      }
      if (webURLRegExp.hasMatch(output)) {
        unique_deploy_url =
            uniqueURLRegExp.stringMatch(output).toString().strip();
      }
      // TODO: return a list of URLS
      // ignore: lines_longer_than_80_chars
      final Map<String, String> outputMap = <String, String>{
        'website_url': website_url ?? '',
        'logs_url': logs_url ?? '',
        'unique_deploy_url': unique_deploy_url ?? '',
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
