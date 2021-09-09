import 'dart:convert';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quatrokantos/constants/site_constants.dart';
import 'package:quatrokantos/models/netlify_account.dart';

class NetlifyAuthService extends GetxService {
  final GetStorage _getStorage = GetStorage();
  final Rx<NetlifyAccount> _user = const NetlifyAccount(
    avatar: '',
    email: '',
    id: '',
    name: '',
    slug: '',
  ).obs;

  @override
  Future<void> onInit() async {
    initAccount();
    super.onInit();
  }

  NetlifyAccount get user {
    return _user.value;
  }

  set user(NetlifyAccount user) {
    _user.value = user;
    _getStorage.write(NETLIFY_ACCOUNT, user.toJson());
  }

  void initAccount() {
    if (_getStorage.hasData(NETLIFY_ACCOUNT)) {
      final String accountStr = _getStorage.read(NETLIFY_ACCOUNT) as String;
      final Map<String, String> accountMap =
          json.decode(accountStr) as Map<String, String>;
      user = NetlifyAccount.fromJson(accountMap);
    }
  }
}
