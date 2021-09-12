import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:quatrokantos/controllers/command_controller.dart';
import 'package:quatrokantos/exceptions/command_failed_exception.dart';
import 'package:quatrokantos/helpers/env_setter.dart';

class Cmd {
  late final String _command;
  late final List<String> _args;
  late final String? _path;
  final CommandController ctrl = Get.find<CommandController>();

  late final Map<String, String>? _env;

  late final bool _runInShell;

  set args(List<String> args) => _args = args;

  List<String> get args => _args;

  set command(String command) => _command = command;

  String get command => _command;

  set path(String? path) => _path = path;

  String? get path => _path;

  set env(Map<String, String>? env) {
    _env = env;
  }

  bool get runInShell => _runInShell;

  set runInShell(bool runInShell) => _runInShell = runInShell;

  Map<String, String>? get env => _env;

  /// #### CLI Helper to Execute Any Commands
  ///
  /// Example Usage:
  ///```
  /// final String command = 'brew';
  /// final List<String> args = ['--version'];
  ///
  /// // We can pass empty List and just a fallback path
  /// // final List<String> paths = <String>[];
  ///
  /// final List<String> paths = <String>[
  ///    '${PC.userDirectory}/.local/opt/brew/bin',
  ///    '/usr/local/bin',
  ///    '/home/linuxbrew/.linuxbrew/bin',
  ///  ];
  ///
  /// final String fallback = '/opt/homebrew/bin';
  ///
  /// final resolvePath =
  ///     await PathHelper.resolve(paths: paths, fallback: fallback);
  ///
  /// final Cmd brew = Cli(args: args, command: command);
  ///
  /// await brew.execute(onResult: (CommandController ctrl, String output) {
  ///    ctrl.results = Cmd.version(output);
  ///
  ///```
  ///
  ///
  Cmd({
    required String command,
    required List<String> args,
    Map<String, String>? env,
    String? path,
    bool runInShell = false,
  })  : _command = command,
        _args = args,
        _path = path,
        _runInShell = runInShell,
        _env = env;

  /// #### `command` executed is relative to `cwd`
  /// ####  When `CommandFailedException` is Thrown on `DEBUG=TRUE` at `.env`
  /// ####  `Error and Stacktrace` is Shown by `Snackbar`
  /// ####  On Release Build set .env `DEBUG=FALSE`
  /// ####  This Logs the Error and Stacktrace at a `~/.local/share/${APP_NAME}/`
  /// ####  Uses CommandController callback to update `results`
  /// ####  To Update any Widget simply do this
  /// #### Example:
  /// ```
  ///       Obx(() => Text('Version: ${ctrl.results}'))
  /// ```
  Future<void> execute({required Function(String output) onResult}) async {
    final StringBuffer outputbuffer = StringBuffer();
    final StringBuffer errorBuffer = StringBuffer();

    try {
      final Process process = await Process.start(
        command,
        args,
        environment:
            env == null ? <String, String>{'PATH': PathEnv.get()} : null,
        workingDirectory: path,
        runInShell: runInShell,
      );

      final Stream<String> outputStream = process.stdout
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());

      await for (final String line in outputStream) {
        outputbuffer.write('$line\n');
      }

      final Stream<String> errorStream = process.stderr
          .transform(const Utf8Decoder())
          .transform(const LineSplitter());
      await for (final String line in errorStream) {
        errorBuffer.write('$line\n');
      }
    } catch (e, stacktrace) {
      errorBuffer.write(stacktrace);
    }

    final String error = errorBuffer.toString();
    final String output = outputbuffer.toString();
    String result = '';

    try {
      if (error.isNotEmpty) {
        // Remove Throwing Exceptions on DEBUG, but we can safely remove this
        if (command != 'netlify' && args != <String>['login']) {
          throw CommandFailedException();
        }
        result = error;
      }
      if (output.isNotEmpty) {
        result = output;
      }
      onResult(result);
    } on CommandFailedException catch (e, stacktrace) {
      CommandFailedException.log(
          e.toString(), '$error\n${stacktrace.toString()}');
    }
  }

  static String? version(String output) {
    final RegExp regExp = RegExp(
      r'(\d+)\.(\d+)\.(\d+)',
    );
    return regExp.stringMatch(output).toString();
  }

  /// #### Executing Two Commands
  /// #### First Command Act as Input for 2nd Command
  /// #### Like `Unix Pipe`, They Both Work The Same way
  /// #### For Example:
  ///```
  ///final String curlPath = p.join('/usr', 'bin');
  /// final String bashPath = p.join('/bin');
  /// const String command1 = 'curl';
  /// const String command2 = 'bash';
  ///
  /// final String path1 =
  ///     await PathHelper.resolve(paths: <String>[], fallback: curlPath);
  ///
  /// final String path2 =
  ///     await PathHelper.resolve(paths: <String>[], fallback: bashPath);
  ///
  ///  await Cmd.pipeTo(
  ///   command1: command1,
  ///   args1: <String>['-sS', 'https://webinstall.dev/webi'],
  ///   path1: path1,
  ///   command2: command2,
  ///   args2: <String>[],
  ///   path2: path2,
  /// );
  ///```
  static Future<void> pipeTo(
      {required String command1,
      required List<String> args1,
      String? path1,
      required String command2,
      required List<String> args2,
      String? path2,
      required Function(bool installed) onDone}) async {
    final CommandController ctrl = Get.find<CommandController>();
    final StringBuffer outputbuffer = StringBuffer();

    try {
      final Process left = await Process.start(
        command1,
        args1,
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: path1,
        runInShell: true,
      );

      final Process right = await Process.start(
        command2,
        args2,
        environment: <String, String>{'PATH': PathEnv.get()},
        workingDirectory: path2,
        runInShell: true,
      );

      left.stdout.pipe(right.stdin);
      right.stdout.transform(utf8.decoder).listen((String event) {
        outputbuffer.write('$event\n');
      }).onDone(() {
        ctrl.results = outputbuffer.toString();
        onDone(true);
      });
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }

  static Future<void> open({
    required String command,
    required List<String> args,
  }) async {
    final CommandController ctrl = Get.find<CommandController>();
    // final StringBuffer outputbuffer = StringBuffer();

    try {
      final Process left = await Process.start(
        command,
        args,
      );

      left.stdout.transform(utf8.decoder).listen((String event) {
        // outputbuffer.write('$event\n');
      }).onDone(() {
        ctrl.results = 'Opening Site ${args[0]}';
      });
    } catch (e, stacktrace) {
      CommandFailedException.log(e.toString(), stacktrace.toString());
    }
  }
}
