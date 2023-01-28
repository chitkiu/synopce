import 'package:get/get.dart';

import '../../../common/data/api_service.dart';
import '../../../common/data/download_station_service/download_station_service.dart';
import 'tasks_info_storage.dart';

class TasksInfoRepository {
  static TasksInfoRepository get repository => Get.find();

  TasksInfoStorage get _storage => TasksInfoStorage.storage;
  DownloadStationService get _dsService => dsService;

  Future<void> loadTasks() async {
    try {
      var result = await _dsService.list();
      _storage.putTasks(result.tasks);
    } on Exception {
      rethrow;
    }
  }
}
