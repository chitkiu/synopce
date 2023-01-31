import 'package:synoapi/synoapi.dart';

import 'download_station_service.dart';

class StubDownloadStationService extends DownloadStationService {

  List<Task> _tasks = [
    Task(
      '1',
      'bt',
      'username',
      'Test title',
      1024,
      TaskStatus.finished,
      null,
      null,
    ),
    Task(
      '2',
      'bt',
      'username',
      'Test title 2',
      1024,
      TaskStatus.paused,
      null,
      null,
    ),
    Task(
      '3',
      'bt',
      'username',
      'Test title 3',
      1024,
      TaskStatus.downloading,
      null,
      null,
    ),
  ];

  @override
  Future<void> create({int? version, List<String>? uris, String? filePath, String? username, String? passwd, String? unzipPasswd, String? destination, bool createList = false}) async {
    //TODO
  }

  @override
  Future<DownloadStationTaskDelete> delete(List<String> ids, bool forceComplete, {int? version}) {
    for (var value in ids) {
      _tasks.removeWhere((element) => element.id == value);
    }
    return Future.value(
        DownloadStationTaskDelete(
          DownloadStationMultiTaskActionResponse(
            []
          )
        )
    );
  }

  @override
  Future<ListTaskInfo> list({int? version, int offset = 0, int limit = -1, List<String> additional = const ['detail', 'transfer', 'file', 'tracker', 'peer']}) {
    return Future.value(
        ListTaskInfo(
          0,
          0,
          _tasks,
        )
    );
  }

  @override
  Future<DownloadStationTaskPause> pause(List<String> ids, {int? version}) {
    for (var value in ids) {
      var item = _tasks.firstWhere((element) => element.id == value);
      item.status = TaskStatus.paused;
    }
    return Future.value(
        DownloadStationTaskPause(
            DownloadStationMultiTaskActionResponse(
              []
            )
        )
    );
  }

  @override
  Future<DownloadStationTaskResume> resume(List<String> ids, {int? version}) {
    for (var value in ids) {
      var item = _tasks.firstWhere((element) => element.id == value);
      item.status = TaskStatus.finished;
    }
    return Future.value(
        DownloadStationTaskResume(
            DownloadStationMultiTaskActionResponse(
                []
            )
        )
    );
  }

}