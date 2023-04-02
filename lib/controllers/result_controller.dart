import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

class ResultController extends GetxController {
  final RxString _results = ''.obs;
  final RxString _errors = ''.obs;

  set results(String value) => _results.value = value;
  set errors(String value) => _errors.value = value;

  String get results => _results.value;
  String get errors => _errors.value;

  @override
  void onInit() {
    ever(_results, logResults);
    ever(_errors, logErrors);
    super.onInit();
  }

  void logResults(String value) {
    if (kDebugMode) {
      print('Result: $value');
    }
  }

  void logErrors(String value) {
    if (kDebugMode) {
      print('Error: $value');
    }
  }
}
