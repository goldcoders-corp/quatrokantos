import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/constants/wizard_contants.dart';

class WizardService extends GetxService {
  final GetStorage _getStorage = GetStorage();

  final RxBool _completed = false.obs;

  @override
  Future<void> onInit() async {
    // checkSaveState();
    completed = false;
    super.onInit();
  }

  void checkSaveState() {
    final bool? done = _getStorage.read(SET_UP_DONE);
    if (done == null) {
      completed = false;
    } else {
      completed = done;
    }
  }

  set completed(bool val) {
    _getStorage.write(SET_UP_DONE, val);
    _completed.value = _getStorage.read(SET_UP_DONE) as bool;
  }

  bool get completed {
    return _completed.value;
  }
}
