import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/models/api_error_exception.dart';
import 'tasks_info_provider.dart';
import 'tasks_info_storage.dart';

class TasksInfoRepository {
  final TasksInfoStorage _storage;
  final TasksInfoProvider _provider;

  TasksInfoRepository(this._storage, this._provider);

  Rx<Map<String, Task>?> get tasks => _storage.tasks;

  Future<void> loadTasks() async {
    var result = await _provider.getData();
    if (result.success) {
      _storage.putTasks(result.data?.tasks ?? List.empty());
    } else {
      throw ApiErrorException(result.error ?? {});
    }
  }
}
