import 'package:synoapi/synoapi.dart';

abstract class DownloadStationService {

  Future<List<DownloadStationTaskActionResponse>> delete(List<String> ids, bool forceComplete,
      {int? version});

  Future<ListTaskInfo> list(
      {int? version,
        int offset = 0,
        int limit = -1,
        List<String> additional = const ['detail', 'transfer', 'file', 'tracker', 'peer']});

  Future<List<DownloadStationTaskActionResponse>> pause(List<String> ids, {int? version});

  Future<List<DownloadStationTaskActionResponse>> resume(List<String> ids, {int? version});

  Future<void> create(
      {int? version,
        List<String>? uris,
        String? filePath,
        String? username,
        String? passwd,
        String? unzipPasswd,
        String? destination,
        bool createList = false});

}