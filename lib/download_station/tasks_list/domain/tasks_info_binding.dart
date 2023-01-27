import 'package:get/get.dart';
import 'package:synopce/common/data/api_service.dart';

import 'tasks_info_controller.dart';

class TasksInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksListController(Get.find<ApiService>().repository));
  }

}