import 'package:synoapi/synoapi.dart';

import 'download_station_service.dart';

class StubDownloadStationService extends DownloadStationService {

  late final List<DownloadStationTask> _tasks;


  StubDownloadStationService() {
    _tasks = [
      _genTask(
        id: '1',
        title: 'Test title',
        status: TaskStatus.finished,
        destination: "Download",
        createTime: DateTime.now().subtract(const Duration(hours: 1)),
      ),
      _genTask(
        id: '2',
        title: 'Test title 2',
        status: TaskStatus.paused,
        destination: "Media",
        createTime: DateTime.now().subtract(const Duration(hours: 2)),
      ),
      _genTask(
        id: '3',
        title: 'Test title 3',
        status: TaskStatus.downloading,
        destination: "Media/Serials",
        createTime: DateTime.now().subtract(const Duration(minutes: 10)),
      ),
    ];
  }

  @override
  Future<void> create({int? version, List<String>? uris, String? filePath, String? username, String? passwd, String? unzipPasswd, String? destination, bool createList = false}) async {
    _tasks.add(
        _genTask(
          id: (_tasks.length + 1).toString(),
          title: filePath ?? uris?.last ?? '',
          status: TaskStatus.hash_checking,
          destination: destination,
        )
    );
  }

  @override
  Future<List<DownloadStationTaskActionResponse>> delete(List<String> ids, bool forceComplete, {int? version}) {
    for (var value in ids) {
      _tasks.removeWhere((element) => element.id == value);
    }
    return Future.value(
        ids.map((e) {
          return DownloadStationTaskActionResponse(
              e,
              null
          );
        }).toList()
    );
  }

  @override
  Future<ListTaskInfo> list({int? version, int offset = 0, int limit = -1, List<String> additional = const ['detail', 'transfer', 'file', 'tracker', 'peer']}) {
    return Future.value(
        ListTaskInfo(
          offset: 0,
          total: 0,
          tasks: _tasks,
        )
    );
  }

  @override
  Future<List<DownloadStationTaskActionResponse>> pause(List<String> ids, {int? version}) {
    for (var value in ids) {
      var item = _tasks.firstWhere((element) => element.id == value);
      item.status = TaskStatus.paused;
    }
    return Future.value(
        ids.map((e) {
          return DownloadStationTaskActionResponse(
              e,
              null
          );
        }).toList()
    );
  }

  @override
  Future<List<DownloadStationTaskActionResponse>> resume(List<String> ids, {int? version}) {
    for (var value in ids) {
      var item = _tasks.firstWhere((element) => element.id == value);
      item.status = TaskStatus.finished;
    }
    return Future.value(
        ids.map((e) {
          return DownloadStationTaskActionResponse(
            e,
            null
          );
        }).toList()
    );
  }

  DownloadStationTask _genTask({
    required String id,
    required String title,
    required TaskStatus status,
    String? destination,
    DateTime? createTime,
  }) {
    return DownloadStationTask(
      id: id,
      type: TaskType.bt,
      username: 'username',
      title: title,
      size: 1024,
      status: status,
      statusExtra: null,
      additional: Additional(
        detail: TaskDetail(
          createTime: createTime ?? DateTime.now(),
          destination: destination,
        ),
      ),
    );
  }

}