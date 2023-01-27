import 'package:get/get.dart';

import '../../../common/sdk.dart';
import 'tasks_info_controller.dart';

class TasksInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TasksListController(SDK.instance.repository));
  }

}