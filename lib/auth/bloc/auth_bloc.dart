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
        if (splitted.length != 2 || splitted[0].isEmpty || splitted[1].isEmpty) {
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
      SDK().init(ConnectionInfo(server, event.username, event.password));
      try {
        var authResult = await SDK().sdk.api.auth();
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
        url: await _storage.read(key: "url") ?? "",
        username: await _storage.read(key: "name") ?? "",
        password: await _storage.read(key: "password") ?? "",
        isHttps: await _storage.read(key: "isHttps") == 'true',
        needToAutologin:
            await _storage.read(key: "needToAutologin") == 'true'));
  }

  void _saveData(LogInPressedAuthEvent event) async {
    _storage.write(key: 'url', value: event.url);
    _storage.write(key: 'name', value: event.username);
    _storage.write(key: 'password', value: event.password);
    _storage.write(key: 'isHttps', value: event.isHttps.toString());
    _storage.write(
        key: 'needToAutologin', value: event.needToAutologin.toString());
  }
}
