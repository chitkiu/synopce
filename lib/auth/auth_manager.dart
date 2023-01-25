import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

import '../extensions/execute_with_loading_dialog.dart';
import '../extensions/snackbar_extension.dart';
import '../main_screen/main_screen.dart';
import '../sdk.dart';
import 'auth_data_model.dart';

class AuthManager extends GetxController {
  final FlutterSecureStorage _storage;

  AuthManager(this._storage);

  Rx<AuthDataModel?> authState = (null as AuthDataModel?).obs;

  @override
  void onInit() async {
    var result = await _loadSavedData();
    await _tryToAuthFromCookie(result);
    authState.value = result;
    super.onInit();
  }

  void updateURL(String newUrl) {
    if (newUrl != authState.value?.url) {
      authState.value = authState.value?.copyWith(
        url: newUrl,
      );
    }
  }

  void updateUsername(String newValue) {
    if (newValue != authState.value?.username) {
      authState.value = authState.value?.copyWith(
        username: newValue,
      );
    }
  }

  void updateIsHttps(bool newValue) {
    if (newValue != authState.value?.isHttps) {
      authState.value = authState.value?.copyWith(
        isHttps: newValue,
      );
    }
  }

  void updateNeedToAutologin(bool newValue) {
    if (newValue != authState.value?.needToAutologin) {
      authState.value = authState.value?.copyWith(
        needToAutologin: newValue,
      );
    }
  }

  Future<AuthDataModel> _loadSavedData() async {
    var result = AuthDataModel(
        url: await _storage.read(key: URL_KEY_NAME) ?? "",
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin:
            await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true');

    return Future.value(result);
  }

  Future<bool> _tryToAuthFromCookie(AuthDataModel authModel) async {
    if (authModel.needToAutologin) {
      try {
        var loadResult = await SDK.instance.initWithCookies(
          url: '${(authModel.isHttps ? 'https' : 'http')}://${authModel.url}',
        );
        if (loadResult) {
          //TODO Find and replace to better endpoint
          var response = await SDK.instance.fsSDK.list.listSharedFolder();
          if (response.success) {
            _goToSettings();
            return true;
          }
        }
      } on Exception catch (e) {
        Get.log.printError(info: e.toString());
      }
    }
    return false;
  }

  void auth(String? password) async {
    var state = authState.value;
    if (state == null) {
      return;
    }
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
    if (password == null || password.isEmpty == true) {
      errorSnackbar("Enter password");
      return;
    }

    executeWithLoadingDialog<bool>(
      () async {
        try {
          var authResult = await SDK.instance.init(
            url: '${(state.isHttps ? 'https' : 'http')}://${state.url}',
            username: state.username,
            password: password ?? "",
          );
          if (authResult) {
            await _saveData();
            return true;
          } else {
            errorSnackbar("Auth failed!");
          }
        } on Exception catch (e) {
          errorSnackbar(e.toString());
        }

        return false;
      },
      actionWithResult: (p0) {
        if (p0 == true) {
          _goToSettings();
        }
      },
    );
  }

  Future<void> _saveData() async {
    var state = authState.value;
    if (state == null) {
      return;
    }
    await _storage.write(key: URL_KEY_NAME, value: state.url);
    await _storage.write(key: USERNAME_KEY_NAME, value: state.username);
    await _storage.write(
        key: IS_HTTPS_KEY_NAME, value: state.isHttps.toString());
    await _storage.write(
        key: NEED_TO_AUTOLOGIN_KEY_NAME,
        value: state.needToAutologin.toString());
  }

  void _goToSettings() {
    Get.offAll(() => MainScreen());
  }

  static const String URL_KEY_NAME = 'url';
  static const String USERNAME_KEY_NAME = 'name';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
  static const String COOKIES_KEY_NAME = 'cookies';
}
