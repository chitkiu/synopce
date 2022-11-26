import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synoapi/synoapi.dart';

import 'download_station/tasks_list/data/tasks_info_provider.dart';
import 'download_station/tasks_list/data/tasks_repository.dart';

class SDK {
  DownloadStationAPI? _dsAPI;
  FileStationAPI? _fsAPI;
  final storage = const FlutterSecureStorage();
  TasksRepository? _repo;

  bool get isInit => _dsAPI != null && _fsAPI != null;

  DownloadStationAPI get dsSDK {
    if (_dsAPI == null) {
      throw Exception("Disk Station API cannot be null");
    }
    return _dsAPI!;
  }

  FileStationAPI get fsSDK {
    if (_fsAPI == null) {
      throw Exception("File Station API cannot be null");
    }
    return _fsAPI!;
  }

  TasksRepository get repository {
    if (_dsAPI == null) {
      throw Exception("Disk Station API cannot be null");
    }
    return _repo!;
  }

  Future<bool> init({
    required String protocol,
    required String host,
    required int port,
    required String username,
    required String password,
  }) async {
    var context = APIContext(host, port: port, proto: protocol);
    var localDsAPI = DownloadStationAPI(context);
    var localFsAPI = FileStationAPI(context);
    return context
        .authApp(Syno.DownloadStation.name, username, password)
        .then((dsResult) async {
      var fsResult =
          await context.authApp(Syno.FileStation.name, username, password);
      return dsResult && fsResult;
    }).then((value) {
      if (value) {
        _dsAPI = localDsAPI;
        _fsAPI = localFsAPI;
        _repo = TasksRepository(TasksInfoProvider(localDsAPI));
      }
      return value;
    });
  }

  static final SDK _singleton = SDK._();

  static SDK get instance => _singleton;

  SDK._();
}
