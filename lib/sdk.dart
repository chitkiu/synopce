import 'package:dsm_app/download_station/task_info_storage.dart';
import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:dsm_sdk/dsm_sdk.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SDK {
  DsmSdk? _sdk;
  final storage = const FlutterSecureStorage();
  final ValueNotifier<List<TaskInfoDetailModel>> tasksValueListener =
      ValueNotifier(List.empty());

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

  static final SDK _singleton = SDK._internal();

  factory SDK() {
    return _singleton;
  }

  SDK._internal();
}
