import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:tint/tint.dart';

class NetlifyLogged {
  NetlifyLogged() : super() {
    args = <String>['login'];
  }
  final String command = 'netlify';
  late final List<String> args;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  Future<Map<String, dynamic>> call() async {
    final path = PathEnv.get();
    final env = <String, String>{
      'PATH': path,
    };
    final cmdPathOrNull = whichSync(
      command,
      environment: (Platform.isWindows) ? null : env,
    );

    final outputbuffer = StringBuffer();
    final errorBuffer = StringBuffer();
    final loginUrlRegex = RegExp(r'(?<=Opening).*?\n');
    final loginUrlBuffer = StringBuffer();
    late final int exitCode;
    late final String? message;
    late final String? url;
    try {
      if (cmdPathOrNull == null) {
        throw CommandFailedException();
      } else {
        final process = await Process.start(
          cmdPathOrNull,
          args,
          environment: env,
        );

        final outputStream = process.stdout
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in outputStream) {
          if (loginUrlRegex.hasMatch('$line\n')) {
            loginUrlBuffer
                .write(loginUrlRegex.stringMatch('$line\n'.strip()).toString());
            break;
          }
          outputbuffer.write('$line\n');
        }
        final loginURL = loginUrlBuffer.toString();
        // we need to highjack to return early
        if (loginURL.isNotEmpty) {
          exitCode = 0;
          message = 'Launch The URL on Browser if it did Not Open.';
          url = loginURL.trim().strip();
          final response = <String, dynamic>{
            'exitCode': exitCode,
            'message': message,
            'url': url
          };
          return response;
        }

        final errorStream = process.stderr
            .transform(const Utf8Decoder())
            .transform(const LineSplitter());
        await for (final String line in errorStream) {
          errorBuffer.write('$line\n');
        }
      }
    } on CommandFailedException catch (_) {
      errorBuffer.write('Command, Not Found');
    } on ProcessException catch (e) {
      errorBuffer.write(e.message);
    }

    final error = errorBuffer.toString();
    final output = outputbuffer.toString().strip();
    if (error.isNotEmpty) {
      exitCode = 2;
      message = error;
      url = null;
      final response = <String, dynamic>{
        'exitCode': exitCode,
        'message': message,
        'url': url
      };
      return response;
    } else {
      exitCode = 0;
      message = output;
      url = null;

      final response = <String, dynamic>{
        'exitCode': exitCode,
        'message': message,
        'pid': pid,
        'url': url
      };
      return response;
    }
  }
}
