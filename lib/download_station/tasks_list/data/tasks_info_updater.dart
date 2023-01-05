import 'dart:async';

import 'package:collection/collection.dart'; // You have to add this manually, for some reason it cannot be added automatically
import 'package:rxdart/rxdart.dart';
import 'package:synoapi/synoapi.dart';

import 'tasks_info_provider.dart';
import 'tasks_model.dart';

class TasksInfoUpdater {
  final TasksInfoProvider tasksInfoProvider;

  TasksInfoUpdater(this.tasksInfoProvider);

  Timer? timer;

  final BehaviorSubject<TasksModel> _dataStream = BehaviorSubject<TasksModel>();

  Stream<TasksModel> get dataStream => _dataStream.stream;

  Stream<Task?> subscribeForSelectedTask(String? taskId) {
    return _dataStream.map((data) {
      if (data is SuccessTasksModel) {
        return data.models.firstWhereOrNull((element) => element.id == taskId);
      } else {
        return null;
      }
    });
  }

  void start() {
    if (timer == null) {
      _loadData();
      timer = Timer.periodic(const Duration(seconds: 3), (timer) async {
        if (_dataStream.hasValue) {
          _dataStream.add(
              _modelWithLoadingStatus(_dataStream.value, true)
          );
        }

        _loadData();
      });
    }
  }

  void stop() {
    timer?.cancel();
    timer = null;
  }

  void _loadData() async {
    var result = await tasksInfoProvider.getData();
    TasksModel response;
    if (result.success) {
      var successValue = result.data?.tasks ?? List.empty();
      response = SuccessTasksModel(successValue, false);
    } else {
      response = ErrorTasksModel(result.error ?? {}, false);
    }
    _dataStream.add(response);
  }

  TasksModel _modelWithLoadingStatus(TasksModel oldModel, bool isLoading) {
    if (oldModel is SuccessTasksModel) {
      return SuccessTasksModel(oldModel.models, isLoading);
    } else if (oldModel is ErrorTasksModel) {
      return ErrorTasksModel(oldModel.errorType, isLoading);
    } else {
      return oldModel;
    }
  }

}