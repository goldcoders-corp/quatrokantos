import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/app.dart';
import 'package:quatrokantos/utils/window_size.dart';

Future<void> main() async {
  await GetStorage.init();
  await dotenv.load();

  minWindowSize();

  runApp(const App());
}
