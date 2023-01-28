import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

class TasksInfoStorage {
  static TasksInfoStorage get storage => Get.find();

  final Rx<Map<String, Task>?> _tasks = Rxn(null);

  Rx<Map<String, Task>?> get tasks => _tasks;

  void putTasks(List<Task> tasks) {
    var newMap = <String, Task>{};
    for (var value in tasks) {
      if (value.id != null) {
        newMap[value.id!] = value;
      }
    }
    _tasks.value = newMap;
  }

}