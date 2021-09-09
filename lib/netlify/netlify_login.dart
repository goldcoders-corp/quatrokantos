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
  final String command = 'netlify';
  late final List<String> args;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  NetlifyLogged() : super() {
    args = <String>['login'];
  }

  Future<Map<String, dynamic>> call() async {
    final String? cmdPathOrNull = whichSync(command,
        environment: <String, String>{'PATH': PathEnv.get()});

    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();
    final RegExp loginUrlRegex = RegExp(r'(?<=Opening).*?\n');
    final StringBuffer loginUrlBuffer = StringBuffer();
    late final int exitCode;
    late final String? message;
    late final String? url;
    try {
      if (cmdPathOrNull == null) {
        throw CommandFailedException();
      } else {
        final Process process = await Process.start(command, args);

        final Stream<String> outputStream = process.stdout
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
        final String loginURL = loginUrlBuffer.toString();
        // we need to highjack to return early
        if (loginURL.isNotEmpty) {
          exitCode = 0;
          message = 'Launch The URL on Browser if it did Not Open.';
          url = loginURL.trim().strip();
          final Map<String, dynamic> response = <String, dynamic>{
            'exitCode': exitCode,
            'message': message,
            'url': url
          };
          return response;
        }

        final Stream<String> errorStream = process.stderr
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

    final String error = errorBuffer.toString();
    final String output = outputbuffer.toString().strip();
    if (error.isNotEmpty) {
      exitCode = 2;
      message = error;
      url = null;
      final Map<String, dynamic> response = <String, dynamic>{
        'exitCode': exitCode,
        'message': message,
        'url': url
      };
      return response;
    } else {
      exitCode = 0;
      message = output;
      url = null;

      final Map<String, dynamic> response = <String, dynamic>{
        'exitCode': exitCode,
        'message': message,
        'pid': pid,
        'url': url
      };
      return response;
    }
  }
}
