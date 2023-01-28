import 'dart:async';

import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/data/api_service.dart';
import '../../../common/data/models/api_error_exception.dart';
import '../../create_task/ui/add_download_screen.dart';

class TasksListController extends GetxController {
  Timer? _timer;

  Rx<bool> isLoading = true.obs;
  Rx<String?> errorText = Rxn(null);
  Rx<Map<String, Task>?> get tasksModel => repository.tasks;
  Rx<String?> selectedTaskModel = Rxn(null);

  TasksListController();

  @override
  void onReady() async {
    await reload();
  }

  @override
  void onClose() {
    _stopTimer();
  }

  void onAddClick() {
    Get.to(() => const AddDownloadTaskWidget());
  }

  Future<void> reload() async {
    _startTimer();
    await _loadData();
  }

  void _startTimer() {
    _timer ??= Timer.periodic(const Duration(seconds: 3), (timer) async {
      _loadData();
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _timer = null;
  }

  Future<void> _loadData() async {
    isLoading.value = true;
    try {
      await repository.loadTasks();
      errorText.value = null;
    } on ApiErrorException catch (e) {
      errorText.value = e.errorType.toString();
      _stopTimer();
    } on Exception catch (e) {
      errorText.value = e.toString();
      _stopTimer();
    }
    isLoading.value = false;
  }

}