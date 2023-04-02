import 'dart:io';

import 'package:get/get.dart';
import 'package:process_run/shell.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/cmd_helper.dart';
import 'package:quatrokantos/helpers/env_setter.dart';
import 'package:quatrokantos/helpers/pc_info_helper.dart';

class HugoInstall {
  HugoInstall() : super() {
    command = 'hugo';
    if (Platform.isWindows) {
      command1 = 'scoop';
      args1
        ..add('install')
        ..add('hugo-extended@0.88.1');
    } else if (Platform.isMacOS) {
      command1 = 'curl';
      args1.add('-sS');
      if (PC.chip == 'Apple M1') {
        args1.add(
          'https://gist.githubusercontent.com/goldcoders/1c5c7b4fb7f574cc468fabacab5a6b68/raw/3b622e2fe1767f7f0183af505549a065ccbdeddf/hugo_extended_mac_arm64.sh',
        );
      } else {
        args1.add(
          'https://gist.githubusercontent.com/goldcoders/1c5c7b4fb7f574cc468fabacab5a6b68/raw/3b622e2fe1767f7f0183af505549a065ccbdeddf/hugo_extended_mac_64bit.sh',
        );
      }
      command2 = 'bash';
      args2 = <String>[];
    } else {
      command1 = 'curl';
      args1
        ..add('-sS')
        ..add(
          'https://gist.githubusercontent.com/goldcoders/1c5c7b4fb7f574cc468fabacab5a6b68/raw/3b622e2fe1767f7f0183af505549a065ccbdeddf/hugo_extended_linux.sh',
        );
      command2 = 'bash';
      args2 = <String>[];
    }
  }
  late final String command;
  late final String command1;
  final List<String> args1 = <String>[];

  late final String command2;
  late final List<String> args2;

  final WizardController wctrl = Get.find<WizardController>();
  final CommandController ctrl = Get.find<CommandController>();

  // ignore: inference_failure_on_function_return_type
  Future<void> call({required Function(bool installed) onDone}) async {
    final cmdPathOrNull = whichSync(
      command,
      environment:
          (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()},
    );

    bool installed;
    if (cmdPathOrNull != null) {
      installed = true;
    } else {
      installed = false;
    }

    if (installed == true) {
      wctrl.hugoInstalled = true;
    } else {
      ctrl.isLoading = true;

      if (Platform.isWindows) {
        await _installOnWindows(onDone: onDone);
      } else {
        try {
          await Cmd.pipeTo(
            command1: command1,
            args1: args1,
            command2: command2,
            args2: args2,
            onDone: onDone,
          );
        } catch (e, stacktrace) {
          await CommandFailedException.log(e.toString(), stacktrace.toString());
        }
      }
    }
  }

  Future<void> _installOnWindows({
    // ignore: inference_failure_on_function_return_type
    required Function(bool installed) onDone,
  }) async {
    final cmdPathOrNull = whichSync(
      command1,
      environment:
          (Platform.isWindows) ? null : <String, String>{'PATH': PathEnv.get()},
    );
    Process.run(
      cmdPathOrNull!,
      args1,
      runInShell: Platform.isWindows,
      workingDirectory: PC.userDirectory,
    ).asStream().listen((ProcessResult data) {
      ctrl.results = data.stdout.toString();
      Process.run(
        'hugo',
        <String>['version'],
        runInShell: true,
        workingDirectory: PC.userDirectory,
      ).asStream().listen((ProcessResult data) {
        final version = Cmd.version(data.stdout.toString());

        if (version != null) {
          onDone(true);
        }
      });
      try {
        if (data.stderr is String &&
            data.stderr.toString().contains(
                  '''
            The remote name could not be resolved:'''
                      .trim(),
                )) {
          throw const ProcessException(
            'scoop',
            <String>[
              'install',
              'hugo-extended',
            ],
          );
        }
      } catch (e, stacktrace) {
        CommandFailedException.log(e.toString(), stacktrace.toString());
      }
    });
  }
}
