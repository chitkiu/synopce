import 'dart:developer';

import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../sdk.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FlutterSecureStorage _storage;

  AuthBloc(this._storage) : super(InitialAuthState()) {
    on<LogInPressedAuthEvent>((event, emit) async {
      log("LogInPressedAuthEvent url ${event.url} username ${event.username} password ${event.password} isHttps ${event.isHttps} needToAutologin ${event.needToAutologin}");
      if (event.url.isEmpty) {
        emit(ErrorAuthState("Enter URL"));
        return;
      } else {
        //TODO Add validation for synology quickaccess id
        var splitted = event.url.split(":");
        if (splitted.length != 2 ||
            splitted[0].isEmpty ||
            splitted[1].isEmpty) {
          emit(ErrorAuthState("Enter valid URL in format ip/host:port"));
          return;
        }
      }
      if (event.username.isEmpty) {
        emit(ErrorAuthState("Enter username"));
        return;
      }
      if (event.password.isEmpty) {
        emit(ErrorAuthState("Enter password"));
        return;
      }

      emit(LoadingAuthState());

      _saveData(event);

      var server =
          Uri.parse("${(event.isHttps ? 'https' : 'http')}://${event.url}");
      SDK.instance.init(ConnectionInfo(server, event.username, event.password));
      try {
        var authResult = await SDK.instance.sdk.authSDK.auth();
        authResult.ifSuccess((_) {
          emit(SuccessLogInAuthState());
        }).ifError((p0) => emit(ErrorAuthState(p0.name)));
      } on Exception catch (e) {
        emit(ErrorAuthState(e.toString()));
      }
    });
    _loadSavedData();
  }

  void _loadSavedData() async {
    emit(UpdateDataAuthState(
        url: await _storage.read(key: URL_KEY_NAME) ?? "",
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        password: await _storage.read(key: PASSWORD_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin:
            await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true'));
  }

  void _saveData(LogInPressedAuthEvent event) async {
    _storage.write(key: URL_KEY_NAME, value: event.url);
    _storage.write(key: USERNAME_KEY_NAME, value: event.username);
    _storage.write(key: PASSWORD_KEY_NAME, value: event.password);
    _storage.write(key: IS_HTTPS_KEY_NAME, value: event.isHttps.toString());
    _storage.write(
        key: NEED_TO_AUTOLOGIN_KEY_NAME,
        value: event.needToAutologin.toString());
  }

  static const String URL_KEY_NAME = 'url';
  static const String USERNAME_KEY_NAME = 'name';
  static const String PASSWORD_KEY_NAME = 'password';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
}
