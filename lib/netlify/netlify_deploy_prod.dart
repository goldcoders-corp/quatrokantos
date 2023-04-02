import 'dart:convert';
import 'dart:io';

import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:tint/tint.dart';

class NetlifyDeploy {
  NetlifyDeploy({required this.path}) : super() {
    args = <String>['deploy', '--prod'];
  }
  final String command = 'ntl';
  final String path;
  late List<String> args;

  Future<Map<String, String>> call() async {
    final buffer = StringBuffer();
    final jsonErrorRegExp = RegExp(r'\bWill\sproceed\swithout\sdeploying\b');
    final siteErrorRegExp =
        RegExp(r"\bThis\sfolder\sisn\'t\slinked\sto\sa\ssite\syet\b");
    final errorMessage = StringBuffer();

    final uniqueURLRegExp = RegExp(r'(?<=Unique Deploy URL:).*?\n');
    final logsRegExp = RegExp(r'(?<=Logs:).*?\n');
    final webURLRegExp = RegExp(r'(?<=Website URL:).*?\n');

    final process = await Process.start(
      command,
      args,
      runInShell: true,
      workingDirectory: path,
      environment:
          (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()},
    );

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
    final output = buffer.toString();
    if (error.isNotEmpty) {
      final errorMap = <String, String>{
        'error': error,
      };
      return errorMap;
    } else if (output.isNotEmpty) {
      String? websiteUrl;
      String? logsUrl;
      String? uniqueDeployUrl;
      if (webURLRegExp.hasMatch(output)) {
        websiteUrl = webURLRegExp.stringMatch(output).toString().strip();
      }
      if (logsRegExp.hasMatch(output)) {
        logsUrl = logsRegExp.stringMatch(output).toString().strip();
      }
      if (webURLRegExp.hasMatch(output)) {
        uniqueDeployUrl =
            uniqueURLRegExp.stringMatch(output).toString().strip();
      }
      // ignore: todo
      // TODO: return a list of URLS
      // ignore: lines_longer_than_80_chars
      final outputMap = <String, String>{
        'website_url': websiteUrl ?? '',
        'logs_url': logsUrl ?? '',
        'unique_deploy_url': uniqueDeployUrl ?? '',
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
