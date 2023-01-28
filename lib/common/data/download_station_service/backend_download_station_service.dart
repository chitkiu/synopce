import 'package:synoapi/synoapi.dart';

import '../api_response_wrapper.dart';
import 'download_station_service.dart';

class BackendDownloadStationService extends DownloadStationService {

  final DownloadStationAPI _api;
  final DownloadStation2API _api2;

  BackendDownloadStationService(APIContext apiContext) : _api = DownloadStationAPI(apiContext),
        _api2 = DownloadStation2API(apiContext);

  @override
  Future<DownloadStationTaskDelete> delete(List<String> ids, bool forceComplete, {int? version}) {
    return wrapRequest(_api.task.delete(ids, forceComplete, version: version));
  }

  @override
  Future<ListTaskInfo> list({int? version, int offset = 0, int limit = -1, List<String> additional = const ['detail', 'transfer', 'file', 'tracker', 'peer']}) {
    return wrapRequest(_api.task.list(version: version, offset: offset, limit: limit, additional: additional));
  }

  @override
  Future<DownloadStationTaskPause> pause(List<String> ids, {int? version}) {
    return wrapRequest(_api.task.pause(ids, version: version));
  }

  @override
  Future<DownloadStationTaskResume> resume(List<String> ids, {int? version}) {
    return wrapRequest(_api.task.resume(ids, version: version));
  }

  @override
  Future<void> create({int? version, List<String>? uris, String? filePath, String? username, String? passwd, String? unzipPasswd, String? destination, bool createList = false}) {
    return wrapRequest(_api2.task.create(version: version, username: username, createList: createList, destination: destination, filePath: filePath, passwd: passwd, unzipPasswd: unzipPasswd, uris: uris));
  }

}