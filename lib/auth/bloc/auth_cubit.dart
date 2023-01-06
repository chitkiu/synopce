import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../sdk.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage _storage;

  AuthCubit(this._storage) : super(InitialAuthState());

  void changeURL(String newURL) => _ifIsDataAuthState((state) {
    if (newURL != state.url) {
      emit(state.copyWith(
        url: newURL,
        error: null,
      ));
    }
  });

  void changeUsername(String newUsername) => _ifIsDataAuthState((state) {
        if (newUsername != state.username) {
          emit(state.copyWith(
            username: newUsername,
            error: null,
          ));
        }
      });

  void changePassword(String newPass) => _ifIsDataAuthState((state) {
        if (newPass != state.password) {
          emit(state.copyWith(
            password: newPass,
            error: null,
          ));
        }
      });

  void isHttps(bool isHttps) => _ifIsDataAuthState((state) {
        if (isHttps != state.isHttps) {
          emit(state.copyWith(
            isHttps: isHttps,
            error: null,
          ));
        }
      });

  void isAutologin(bool isAutologin) => _ifIsDataAuthState((state) {
        if (isAutologin != state.needToAutologin) {
          emit(state.copyWith(
            needToAutologin: isAutologin,
            error: null,
          ));
        }
      });

  void hidePassword(bool hidePassword) => _ifIsDataAuthState((state) {
        if (hidePassword != state.hidePassword) {
          emit(state.copyWith(
            hidePassword: hidePassword,
            error: null,
          ));
        }
      });

  void auth() => _ifIsDataAuthState((state) async {
        log("LogInPressedAuthEvent url ${state.url} username ${state.username} password ${state.password} isHttps ${state.isHttps} needToAutologin ${state.needToAutologin}");

        if (state.url.isEmpty) {
          emit(state.copyWith(error: "Enter URL"));
          return;
        } else {
          //TODO Add validation for synology quickaccess id
          var splitted = state.url.split(":");
          if (splitted.length != 2 ||
              splitted[0].isEmpty ||
              splitted[1].isEmpty) {
            emit(state.copyWith(
                error: "Enter valid URL in format ip/host:port"));
            return;
          }
        }
        if (state.username.isEmpty) {
          emit(state.copyWith(error: "Enter username"));
          return;
        }
        if (state.password.isEmpty) {
          emit(state.copyWith(error: "Enter password"));
          return;
        }

        emit(state.copyWith(state: InternalAuthState.LOADING));

        _saveData();
        try {
          var authResult = await SDK.instance.init(
            url: '${(state.isHttps ? 'https' : 'http')}://${state.url}',
            username: state.username,
            password: state.password,
          );
          if (authResult) {
            emit(state.copyWith(state: InternalAuthState.SUCCESS));
          } else {
            emit(state.copyWith(error: "Auth failed"));
          }
        } on Exception catch (e) {
          emit(state.copyWith(error: e.toString()));
        }
      });

  void _saveData() => _ifIsDataAuthState((state) async {
        _storage.write(key: URL_KEY_NAME, value: state.url);
        _storage.write(key: USERNAME_KEY_NAME, value: state.username);
        _storage.write(key: IS_HTTPS_KEY_NAME, value: state.isHttps.toString());
        _storage.write(
            key: NEED_TO_AUTOLOGIN_KEY_NAME,
            value: state.needToAutologin.toString());
      });

  void loadSavedData() async {
    var newState = DataAuthState(
        url: await _storage.read(key: URL_KEY_NAME) ?? "",
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin:
            await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true');
    emit(newState);

    if (newState.needToAutologin) {
      try {
        var loadResult = await SDK.instance.initWithCookies(
          url: '${(newState.isHttps ? 'https' : 'http')}://${newState.url}',
        );
        if (loadResult) {
          //TODO
          var response = await SDK.instance.fsSDK.list.listSharedFolder();
          if (response.success) {
            emit(newState.copyWith(state: InternalAuthState.SUCCESS));
            return;
          }
        }
      } on Exception catch (e) {
        print(e);
      }

      emit(newState.copyWith(state: null));
    }
  }

  void _ifIsDataAuthState(Function(DataAuthState state) f) {
    var currentState = state;
    if (currentState is DataAuthState) {
      f(currentState);
    }
  }

  static const String URL_KEY_NAME = 'url';
  static const String USERNAME_KEY_NAME = 'name';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
  static const String COOKIES_KEY_NAME = 'cookies';
}
