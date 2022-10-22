import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:dsm_sdk/dsm_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SDK {
  DsmSdk? _sdk;
  final storage = const FlutterSecureStorage();

  bool get isInit => _sdk != null;

  DsmSdk get sdk {
    if (_sdk == null) {
      throw Exception("SDK cannot be null");
    }
    return _sdk!;
  }

  void init(ConnectionInfo connectionInfo) {
    _sdk = DsmSdk(connectionInfo);
  }

  static final SDK _singleton = SDK._();

  static SDK get instance => _singleton;

  SDK._();
}
