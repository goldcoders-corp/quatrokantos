// ignore_for_file: inference_failure_on_function_invocation

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeService extends GetxService {
  final GetStorage _getStorage = GetStorage();
  final String _storageKey = 'ThemeDark';
  final RxBool _isDarkMode = false.obs;
  @override
  void onInit() {
    isDarkMode = _getStorage.read(_storageKey) ?? false;
    super.onInit();
  }

  ThemeMode getThemeMode() {
    if (_getStorage.hasData(storageKey) &&
        _getStorage.read(storageKey) == true) {
      return ThemeMode.dark;
    } else {
      return ThemeMode.light;
    }
  }

  String get storageKey {
    return _storageKey;
  }

  bool get isDarkMode {
    return _isDarkMode.value;
  }

  set isDarkMode(bool val) {
    _isDarkMode.value = val;
  }

  void _saveThemeMode() {
    _isDarkMode.toggle();
    _getStorage.write(_storageKey, isDarkMode);
  }

  void changeThemeMode() {
    _saveThemeMode();
    Get.changeThemeMode(getThemeMode());
  }
}
