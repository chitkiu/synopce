import 'package:get/get.dart';

import '../../app_route_type.dart';
import '../../common/data/api_service.dart';
import '../../common/extensions/execute_with_loading_dialog.dart';
import '../../common/extensions/snackbar_extension.dart';
import '../data/auth_service/auth_service.dart';
import '../data/auth_service/stub_auth_service.dart';
import '../data/local_auth_data_storage.dart';
import '../data/models/auth_data_model.dart';
import '../data/models/local_auth_data_model.dart';

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
      _localDataStorage.changeNeedToAutologin(newValue);
    }
  }

  Future<bool> _tryToAuthFromCookie(LocalAuthDataModel authModel) async {
    if (authModel.needToAutologin) {
      try {
        var loadResult = await Get
            .find<AuthService>()
            .logInWithCookie(
            AuthDataModel(
                '${(authModel.isHttps ? 'https' : 'http')}://${authModel.url}',
                null,
                null
            )
        );
        if (loadResult) {
          _goToMainScreen();
          return true;
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

    bool result = await _auth(state, password);
    if (result) {
      await _localDataStorage.saveData(authState.value);
    }
  }

  void startDemoMode() async {
    Get.delete<AuthService>();
    Get.put(StubAuthService(() {
      Get.find<ApiService>().stubInit();
    }) as AuthService);

    await _auth(
        LocalAuthDataModel(
          url: "",
          username: "",
          needToAutologin: false,
          isHttps: false,
        ),
        ""
    );
  }

  Future<bool> _auth(LocalAuthDataModel state, String password) {
    return executeWithLoadingDialog<bool>(
          () async {
        try {
          var authResult = await Get
              .find<AuthService>()
              .logIn(
              AuthDataModel(
                  '${(state.isHttps ? 'https' : 'http')}://${state.url}',
                  state.username,
                  password
              )
          );
          if (authResult) {
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
