import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

class TasksInfoStorage {

  final _tasks = (null as Map<String, Task>?).obs;

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