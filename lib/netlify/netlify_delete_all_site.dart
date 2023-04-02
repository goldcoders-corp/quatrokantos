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
    final siteIds = await fetch();
    if (siteIds.isNotEmpty) {
      for (final element in siteIds) {
        final id = element.strip().trim();
        final message = await delete(id);
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
    // ignore: todo
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final buffer = StringBuffer();
    final args = <String>['sites:delete', '-f', id];

    final process = await Process.start(command, args);
    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }

    final output = buffer.toString().strip();
    final exitCode = await process.exitCode;
    if (exitCode >= 1) {
      return 'Error: Failed to Execute Site Deletion';
    } else {
      return output;
    }
  }

  Future<Iterable<String>> fetch() async {
    // ignore: todo
    //TODO: Only Allow to Execute this Command if we are Authenticated!
    // Coz we will be redirected to Authentication Page if we do
    final buffer = StringBuffer();
    final args = <String>['sites:list'];
    final regExp = RegExp(r'[\w]{8}(-[\w]{4}){3}-[\w]{12}');
    final process = await Process.start(command, args);
    final lineStream = process.stdout
        .transform(const Utf8Decoder())
        .transform(const LineSplitter());
    await for (final String line in lineStream) {
      buffer.write(line);
    }
    final output = buffer.toString().strip();

    if (output.isNotEmpty) {
      final Iterable<Match> matches = regExp.allMatches(output);
      final listOfMatches = matches.toList();

      final siteIds = listOfMatches.map((Match m) {
        return m.input.substring(m.start, m.end);
      });
      return siteIds;
    } else {
      // ignore: always_specify_types
      return List.empty();
    }
  }
}
