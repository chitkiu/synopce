import 'package:get/get.dart';

import '../../../common/domain/deletable_bindings.dart';
import '../../../common/extensions/getx_extensions.dart';
import '../data/tasks_info_repository.dart';
import '../data/tasks_info_storage.dart';
import 'tasks_info_controller.dart';

class TasksInfoBinding extends DeletableBindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksInfoStorage());
    Get.lazyPut(() => TasksInfoRepository());
    Get.lazyPut(() => TasksListController());
  }

  @override
  void delete() {
    Get.deleteIfExist<TasksListController>();
    Get.deleteIfExist<TasksInfoRepository>();
    Get.deleteIfExist<TasksInfoStorage>();
  }

}