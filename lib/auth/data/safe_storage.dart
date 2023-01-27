import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synoapi/synoapi.dart';

const String STORAGE_PREFIX = "cookie_";

class SafeStorage implements Storage {
  final FlutterSecureStorage _storage;

  SafeStorage(this._storage);

  Future<void> wipe() async {
    var cookieData = await _storage.readAll();
    for (MapEntry<String, String> entry in cookieData.entries) {
      if (entry.key.startsWith(STORAGE_PREFIX)) {
        await _storage.delete(key: entry.key);
      }
    }
  }

  Future<Map<String, String>> readAll() {
    return _storage.readAll();
  }

  @override
  Future<void> delete(String key) {
    return _storage.delete(key: STORAGE_PREFIX+key);
  }

  @override
  Future<void> deleteAll(List<String> keys) async {
    for (var element in keys) {
      await delete(element);
    }
  }

  @override
  Future<void> init(bool persistSession, bool ignoreExpires) async {
  }

  @override
  Future<String?> read(String key) async {
    var response = await _storage.read(key: STORAGE_PREFIX+key);
    return response;
  }

  @override
  Future<void> write(String key, String value) {
    return _storage.write(
      key: STORAGE_PREFIX+key,
      value: value,
    );
  }
}
