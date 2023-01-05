import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synoapi/synoapi.dart';

import 'download_station/tasks_list/data/tasks_info_provider.dart';
import 'download_station/tasks_list/data/tasks_info_updater.dart';

class SDK {
  late final DownloadStationAPI dsSDK;
  late final DownloadStation2API ds2SDK;
  late final FileStationAPI fsSDK;
  final storage = const FlutterSecureStorage();
  late final TasksInfoProvider provider;
  late final TasksInfoUpdater updater;

  Future<bool> init({
    required String url,
    required String username,
    required String password,
  }) async {
    var context = APIContext.uri(url);
    var localDsAPI = DownloadStationAPI(context);
    var localDs2API = DownloadStation2API(context);
    var localFsAPI = FileStationAPI(context);
    return context
        .authApp(username, password)
        .then((value) {
      if (value) {
        dsSDK = localDsAPI;
        ds2SDK = localDs2API;
        fsSDK = localFsAPI;
        provider = TasksInfoProvider(localDsAPI);
        updater = TasksInfoUpdater(provider);
      }
      return value;
    });
  }

  static final SDK instance = SDK._();

  SDK._();
}
