import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

class TasksInfoStorage {
  static TasksInfoStorage get storage => Get.find();

  final Rx<Map<String, DownloadStationTask>?> _tasks = Rxn(null);

  Rx<Map<String, DownloadStationTask>?> get tasks => _tasks;

  void putTasks(List<DownloadStationTask> tasks) {
    var newMap = <String, DownloadStationTask>{};
    for (var value in tasks) {
      newMap[value.id] = value;
    }
    _tasks.value = newMap;
  }

}