import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../../sdk.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final FlutterSecureStorage _storage;

  AuthCubit(this._storage) : super(InitialAuthState());

  void changeHost(String newHost) => _ifIsDataAuthState((state) {
        if (newHost != state.host) {
          emit(state.copyWith(
            host: newHost,
          ));
        }
      });

  void changePort(String newPort) => _ifIsDataAuthState((state) {
        var parsedPort = int.parse(newPort);
        if (parsedPort != state.port) {
          emit(state.copyWith(
            port: parsedPort,
          ));
        }
      });

  void changeUsername(String newUsername) => _ifIsDataAuthState((state) {
        if (newUsername != state.username) {
          emit(state.copyWith(
            username: newUsername,
          ));
        }
      });

  void changePassword(String newPass) => _ifIsDataAuthState((state) {
        if (newPass != state.password) {
          emit(state.copyWith(
            password: newPass,
          ));
        }
      });

  void isHttps(bool isHttps) => _ifIsDataAuthState((state) {
        if (isHttps != state.isHttps) {
          emit(state.copyWith(
            isHttps: isHttps,
          ));
        }
      });

  void isAutologin(bool isAutologin) => _ifIsDataAuthState((state) {
        if (isAutologin != state.needToAutologin) {
          emit(state.copyWith(
            needToAutologin: isAutologin,
          ));
        }
      });

  void hidePassword(bool hidePassword) => _ifIsDataAuthState((state) {
        if (hidePassword != state.hidePassword) {
          emit(state.copyWith(
            hidePassword: hidePassword,
          ));
        }
      });

  void auth() => _ifIsDataAuthState((state) async {
        log("LogInPressedAuthEvent host ${state.host} port ${state.port} username ${state.username} password ${state.password} isHttps ${state.isHttps} needToAutologin ${state.needToAutologin}");

        //TODO Add validation for synology quickaccess id
        if (state.host.isEmpty) {
          emit(state.copyWith(error: "Enter URL"));
          return;
        }
        if (state.port <= 0) {
          emit(state.copyWith(error: "Enter valid port number"));
          return;
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
            protocol: (state.isHttps ? 'https' : 'http'),
            host: state.host,
            port: state.port,
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
        _storage.write(key: HOST_KEY_NAME, value: state.host);
        _storage.write(key: PORT_KEY_NAME, value: state.port.toString());
        _storage.write(key: USERNAME_KEY_NAME, value: state.username);
        _storage.write(key: PASSWORD_KEY_NAME, value: state.password);
        _storage.write(key: IS_HTTPS_KEY_NAME, value: state.isHttps.toString());
        _storage.write(
            key: NEED_TO_AUTOLOGIN_KEY_NAME,
            value: state.needToAutologin.toString());
      });

  void loadSavedData() async {
    var host = await _storage.read(key: HOST_KEY_NAME) ?? "";
    var port = await _storage.read(key: PORT_KEY_NAME) ?? "";
    //TODO Remove this part of parsing after start app on all platform
    var url = await _storage.read(key: URL_KEY_NAME);
    if (url != null) {
      var splitHostAndPort = url.split(":");
      if (splitHostAndPort.length == 2) {
        if (host.isEmpty) {
          host = splitHostAndPort[0];
        }
        if (port.isEmpty) {
          port = splitHostAndPort[1];
        }
      }
      _storage.delete(key: URL_KEY_NAME);
    }
    var newState = DataAuthState(
        host: host,
        port: int.parse(port),
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        password: await _storage.read(key: PASSWORD_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin:
            await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true');
    log(newState.toString());
    emit(newState);
    if (newState.needToAutologin) {
      auth();
    }
  }

  void _ifIsDataAuthState(Function(DataAuthState state) f) {
    var currentState = state;
    if (currentState is DataAuthState) {
      f(currentState);
    }
  }

  static const String URL_KEY_NAME = 'url';
  static const String HOST_KEY_NAME = 'host';
  static const String PORT_KEY_NAME = 'port';
  static const String USERNAME_KEY_NAME = 'name';
  static const String PASSWORD_KEY_NAME = 'password';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
}
