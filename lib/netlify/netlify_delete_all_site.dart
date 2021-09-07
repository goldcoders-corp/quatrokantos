import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tint/tint.dart';

class NetlifyDeleteAllSites {
  final String command = 'ntl';

  final List<String> sites = <String>[];

  Future<void> all() async {
    // ignore: always_specify_types
    final Iterable<String> site_ids = await fetch();
    if (site_ids.isNotEmpty) {
      for (final String element in site_ids) {
        final String id = element.strip().trim();
        final String message = await delete(id);
        Get.snackbar(
          'Notification',
          message,
          icon: const Icon(Icons.warning, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      Get.snackbar(
        'Notification',
        'No Site to be Deleted!',
        icon: const Icon(Icons.warning, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<String> delete(String id) async {
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final StringBuffer buffer = StringBuffer();
    final List<String> args = <String>['sites:delete', '-f'];

    args.add(id);

    final Process process = await Process.start(command, args);
    final Stream<String> lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }

    final String output = buffer.toString().strip();
    final int exitCode = await process.exitCode;
    if (exitCode >= 1) {
      return 'Error: Failed to Execute Site Deletion';
    } else {
      return output;
    }
  }

  Future<Iterable<String>> fetch() async {
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final StringBuffer buffer = StringBuffer();
    final List<String> args = <String>['sites:list'];
    final RegExp regExp = RegExp(r'[\w]{8}(-[\w]{4}){3}-[\w]{12}');
    final Process process = await Process.start(command, args);
    final Stream<String> lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }
    final String output = buffer.toString().strip();

    if (output.isNotEmpty) {
      final Iterable<Match> matches = regExp.allMatches(output);
      final List<Match> listOfMatches = matches.toList();

      final Iterable<String> site_ids = listOfMatches.map((Match m) {
        return m.input.substring(m.start, m.end);
      });
      return site_ids;
    } else {
      // ignore: always_specify_types
      return List.empty();
    }
  }
}
