import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/download_station_service/download_station_service.dart';
import 'tasks_info_storage.dart';

class TasksInfoRepository {
  final TasksInfoStorage _storage;
  final DownloadStationService _dsService;

  TasksInfoRepository(this._storage, this._dsService);

  Rx<Map<String, Task>?> get tasks => _storage.tasks;

  Future<void> loadTasks() async {
    try {
      var result = await _dsService.list();
      _storage.putTasks(result.tasks);
    } on Exception {
      rethrow;
    }
  }
}
