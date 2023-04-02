// ignore_for_file: inference_failure_on_function_invocation

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/app/modules/wizard/controllers/wizard_controller.dart';
import 'package:quatrokantos/constants/site_constants.dart';
import 'package:quatrokantos/models/netlify_account.dart';
import 'package:quatrokantos/netlify/netlify_logout.dart';
import 'package:quatrokantos/services/wizard_service.dart';

class NetlifyAuthService extends GetxService {
  final GetStorage _getStorage = GetStorage();
  final WizardController stepper = Get.find<WizardController>();
  WizardService wizard = Get.find<WizardService>();
  final Rx<NetlifyAccount> _user = const NetlifyAccount(
    avatar: '',
    email: '',
    id: '',
    name: '',
    slug: '',
  ).obs;

  final RxBool _isLogged = false.obs;

  @override
  Future<void> onInit() async {
    initAccount();
    super.onInit();
  }

  void logout() {
    _netlifyLogout();
    emptyAccount();
    wizard.completed = false;
    stepper
      ..netlifyLogged = false
      ..complete = false;
    Get.toNamed('/wizard');
  }

  Future<void> _netlifyLogout() async {
    await NetlifyLogout()();
  }

  void emptyAccount() {
    user = const NetlifyAccount(
      avatar: '',
      email: '',
      id: '',
      name: '',
      slug: '',
    );
  }

  bool get isLogged {
    if (user.email == '' &&
        user.name == '' &&
        user.id == '' &&
        user.avatar == '') {
      return false;
    }
    return _isLogged.value;
  }

  set isLogged(bool val) => _isLogged.value = val;

  NetlifyAccount get user {
    return _user.value;
  }

  set user(NetlifyAccount user) {
    _user.value = user;
    _getStorage.write(NETLIFY_ACCOUNT, user.toJson());
  }

  void initAccount() {
    if (_getStorage.hasData(NETLIFY_ACCOUNT)) {
      final accountMap =
          _getStorage.read(NETLIFY_ACCOUNT) as Map<String, dynamic>;
      user = NetlifyAccount.fromJson(accountMap);
    }
  }
}
