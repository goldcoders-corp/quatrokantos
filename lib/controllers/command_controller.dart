import 'package:get/get.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class CommandController extends GetxController {
  final RxString _results = ''.obs;
  final RxBool _loading = false.obs;

  String get results => _results.value;

  set results(String val) => _results.value = val;

  bool get isLoading => _loading.value;

  set isLoading(bool val) => _loading.value = val;
}
