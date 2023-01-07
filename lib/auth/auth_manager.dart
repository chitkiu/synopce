import 'package:dsm_app/auth/auth_data_model.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../extensions/snackbar_extension.dart';
import '../sdk.dart';
import '../settings/settings_screen.dart';

class AuthManager extends GetxController {
  final FlutterSecureStorage _storage;

  AuthManager(this._storage);

  var authState = const AuthDataModel(
          url: "",
          username: "",
          needToAutologin: false,
          isHttps: false)
      .obs;

  var hidePassword = true.obs;


  @override
  void onInit() async {
    var result = await loadSavedData();
    authState.value = result;
    await tryToAuthFromCookie(result);
    super.onInit();
  }

  void updateURL(String newUrl) {
    if (newUrl != authState.value.url) {
      authState.value = authState.value.copyWith(
        url: newUrl,
      );
    }
  }

  void updateUsername(String newValue) {
    if (newValue != authState.value.username) {
      authState.value = authState.value.copyWith(
        username: newValue,
      );
    }
  }

  void updateIsHttps(bool newValue) {
    if (newValue != authState.value.isHttps) {
      authState.value = authState.value.copyWith(
        isHttps: newValue,
      );
    }
  }

  void updateNeedToAutologin(bool newValue) {
    if (newValue != authState.value.needToAutologin) {
      authState.value = authState.value.copyWith(
        needToAutologin: newValue,
      );
    }
  }

  Future<AuthDataModel> loadSavedData() async {
    var result = AuthDataModel(
        url: await _storage.read(key: URL_KEY_NAME) ?? "",
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin:
            await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true');

    return Future.value(result);
  }

  Future<void> tryToAuthFromCookie(AuthDataModel authModel) async {
    if (authModel.needToAutologin) {
      try {
        var loadResult = await SDK.instance.initWithCookies(
          url: '${(authModel.isHttps ? 'https' : 'http')}://${authModel.url}',
        );
        if (loadResult) {
          //TODO Find and replace to better endpoint
          var response = await SDK.instance.fsSDK.list.listSharedFolder();
          if (response.success) {
            Get.offAll(() => const SettingsScreen());
          }
          return;
        }
      } on Exception catch (e) {
        print(e);
      }
    }
  }

  void auth(String? password) async {
    var state = authState.value;
    if (state.url.isEmpty) {
      errorSnackbar("Enter URL");
      return;
    } else {
      //TODO Add validation for synology quickaccess id
      var splitted = state.url.split(":");
      if (splitted.length != 2 || splitted[0].isEmpty || splitted[1].isEmpty) {
        errorSnackbar("Enter valid URL in format ip/host:port");
        return;
      }
    }
    if (state.username.isEmpty) {
      errorSnackbar("Enter username");
      return;
    }
    if (password == null || password!.isEmpty == true) {
      errorSnackbar("Enter password");
      return;
    }

    _saveData();
    try {
      var authResult = await SDK.instance.init(
        url: '${(state.isHttps ? 'https' : 'http')}://${state.url}',
        username: state.username,
        password: password ?? "",
      );
      if (authResult) {
        Get.offAll(() => const SettingsScreen());
      } else {
        errorSnackbar("Auth failed!");
      }
    } on Exception catch (e) {
      errorSnackbar(e.toString());
    }
  }

  void _saveData() {
    _storage.write(key: URL_KEY_NAME, value: authState.value.url);
    _storage.write(key: USERNAME_KEY_NAME, value: authState.value.username);
    _storage.write(
        key: IS_HTTPS_KEY_NAME, value: authState.value.isHttps.toString());
    _storage.write(
        key: NEED_TO_AUTOLOGIN_KEY_NAME,
        value: authState.value.needToAutologin.toString());
  }

  static const String URL_KEY_NAME = 'url';
  static const String USERNAME_KEY_NAME = 'name';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
  static const String COOKIES_KEY_NAME = 'cookies';
}
