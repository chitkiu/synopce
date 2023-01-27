import 'package:get/get.dart';

import '../../../sdk.dart';
import 'tasks_info_controller.dart';

class TasksInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksListController(SDK.instance.repository));
  }

}