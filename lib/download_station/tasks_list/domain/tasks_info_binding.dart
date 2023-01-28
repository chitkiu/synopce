import 'package:get/get.dart';

import '../data/tasks_info_repository.dart';
import '../data/tasks_info_storage.dart';
import 'tasks_info_controller.dart';

class TasksInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksInfoStorage());
    Get.lazyPut(() => TasksInfoRepository());
    Get.lazyPut(() => TasksListController());
  }

}