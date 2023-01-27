import 'package:get/get.dart';
import 'package:synopce/auth/data/models/local_auth_data_model.dart';

import '../../app_route_type.dart';
import '../../common/extensions/execute_with_loading_dialog.dart';
import '../../common/extensions/snackbar_extension.dart';
import '../../common/sdk.dart';
import '../data/local_auth_data_storage.dart';

class AuthScreenController extends GetxController {
  final LocalAuthDataStorage _localDataStorage;

  AuthScreenController(this._localDataStorage);

  Rx<LocalAuthDataModel?> authState = Rxn(null);

  @override
  void onInit() async {
    var result = await _localDataStorage.loadSavedData();
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

  Future<bool> _tryToAuthFromCookie(LocalAuthDataModel authModel) async {
    if (authModel.needToAutologin) {
      try {
        var loadResult = await SDK.instance.initWithCookies(
          url: '${(authModel.isHttps ? 'https' : 'http')}://${authModel.url}',
        );
        if (loadResult) {
          //TODO Find and replace to better endpoint
          var response = await SDK.instance.fsSDK.list.listSharedFolder();
          if (response.success) {
            _goToMainScreen();
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
            password: password,
          );
          if (authResult) {
            await _localDataStorage.saveData(authState.value);
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
          _goToMainScreen();
        }
      },
    );
  }

  void _goToMainScreen() {
    Get.offAllNamed(AppRouteType.main.route);
  }
}
