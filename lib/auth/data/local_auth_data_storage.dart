import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'models/local_auth_data_model.dart';

class LocalAuthDataStorage {
  final FlutterSecureStorage _storage;

  LocalAuthDataStorage(this._storage);

  Future<LocalAuthDataModel> loadSavedData() async {
    var result = LocalAuthDataModel(
        url: await _storage.read(key: URL_KEY_NAME) ?? "",
        username: await _storage.read(key: USERNAME_KEY_NAME) ?? "",
        isHttps: await _storage.read(key: IS_HTTPS_KEY_NAME) == 'true',
        needToAutologin: await _storage.read(key: NEED_TO_AUTOLOGIN_KEY_NAME) == 'true'
    );

    return result;
  }

  Future<void> saveData(LocalAuthDataModel? model) async {
    if (model == null) {
      return;
    }
    await _storage.write(key: URL_KEY_NAME, value: model.url);
    await _storage.write(key: USERNAME_KEY_NAME, value: model.username);
    await _storage.write(
        key: IS_HTTPS_KEY_NAME, value: model.isHttps.toString());
    await _storage.write(
        key: NEED_TO_AUTOLOGIN_KEY_NAME,
        value: model.needToAutologin.toString());
  }

  static const String URL_KEY_NAME = 'url';
  static const String USERNAME_KEY_NAME = 'name';
  static const String IS_HTTPS_KEY_NAME = 'isHttps';
  static const String NEED_TO_AUTOLOGIN_KEY_NAME = 'needToAutologin';
  static const String COOKIES_KEY_NAME = 'cookies';
}
