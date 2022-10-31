import 'package:dsm_sdk/core/models/connection_info.dart';
import 'package:dsm_sdk/dsm_sdk.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'download_station/tasks_list/data/tasks_info_provider.dart';
import 'download_station/tasks_list/data/tasks_repository.dart';

class SDK {
  DsmSdk? _sdk;
  final storage = const FlutterSecureStorage();
  TasksRepository? _repo;

  bool get isInit => _sdk != null;

  DsmSdk get sdk {
    if (_sdk == null) {
      throw Exception("SDK cannot be null");
    }
    return _sdk!;
  }

  TasksRepository get repository {
    if (_sdk == null) {
      throw Exception("SDK cannot be null");
    }
    return _repo!;
  }

  void init(ConnectionInfo connectionInfo) {
    var localSDK = DsmSdk(connectionInfo);
    _sdk = localSDK;
    _repo = TasksRepository(TasksInfoProvider(localSDK));
  }

  static final SDK _singleton = SDK._();

  static SDK get instance => _singleton;

  SDK._();
}
