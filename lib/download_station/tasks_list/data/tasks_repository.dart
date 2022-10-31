import 'dart:async';

import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

import '../bloc/tasks/tasks_state.dart';
import 'tasks_info_provider.dart';

class TasksRepository {
  final TasksInfoProvider tasksInfoProvider;

  TasksRepository(this.tasksInfoProvider);

  //TODO Try to find better way
  final StreamController<List<TaskInfoDetailModel>> _successDataStream =
      StreamController<List<TaskInfoDetailModel>>.broadcast();

  Stream<List<TaskInfoDetailModel>> get successDataStream =>
      _successDataStream.stream;

  Future<TasksState> getData() async {
    var result = await tasksInfoProvider.getData();
    TasksState response;
    if (result.isSuccess) {
      response = SuccessTasksState(result.successValue.tasks, false);
      _successDataStream.add(result.successValue.tasks);
    } else {
      response = ErrorTasksState(result.errorValue, false);
    }

    return Future.value(response);
  }

  Future<TasksState> removeItem(String id, TasksState state) async {
    var result = await tasksInfoProvider.removeItem(id);
    if (result.isSuccess && state.isSuccess) {
      var successState = (state as SuccessTasksState);
      var models = successState.models.toList();
      models.removeWhere((element) => element.id == id);
      return Future.value(SuccessTasksState(models, false));
    } else {
      return Future.value(state);
    }
  }
}
