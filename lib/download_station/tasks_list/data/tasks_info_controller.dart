import 'dart:async';

import 'package:dsm_app/common/data/api_error_exception.dart';
import 'package:dsm_app/common/data/tasks_info_repository.dart';
import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../create_task/add_download_screen.dart';

class TasksListController extends GetxController {
  final TasksInfoRepository _repository;

  Timer? timer;

  Rx<bool> isLoading = true.obs;
  Rx<String?> errorText = (null as String?).obs;
  Rx<Map<String, Task>?> get tasksModel => _repository.tasks;
  Rx<String?> selectedTaskModel = (null as String?).obs;

  TasksListController(this._repository);


  @override
  void onReady() async {
    await _loadData();
    timer ??= Timer.periodic(const Duration(seconds: 3), (timer) async {
      _loadData();
    });
  }

  @override
  void onClose() {
    timer?.cancel();
    timer = null;
  }

  void onAddClick() {
    Get.to(() => const AddDownloadTaskWidget());
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await _repository.loadTasks();
      errorText.value = null;
    } on ApiErrorException catch (e) {
      errorText.value = e.errorType.toString();
    }
    isLoading.value = false;
  }

}