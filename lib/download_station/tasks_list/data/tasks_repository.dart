import 'dart:async';

import 'package:synoapi/synoapi.dart';

import '../bloc/tasks/tasks_state.dart';
import 'tasks_info_provider.dart';

class TasksRepository {
  final TasksInfoProvider tasksInfoProvider;

  TasksRepository(this.tasksInfoProvider);

  //TODO Try to find better way
  final StreamController<List<Task>> _successDataStream =
      StreamController<List<Task>>.broadcast();

  Stream<List<Task>> get successDataStream =>
      _successDataStream.stream;

  Future<TasksState> getData() async {
    var result = await tasksInfoProvider.getData();
    TasksState response;
    if (result.success) {
      var successValue = result.data?.tasks ?? List.empty();
      response = SuccessTasksState(successValue, false);
      _successDataStream.add(successValue);
    } else {
      response = ErrorTasksState(result.error ?? {}, false);
    }

    return Future.value(response);
  }

  Future<TasksState> removeItem(String id, TasksState state) async {
    var result = await tasksInfoProvider.removeItem(id);
    if (result.success && state.isSuccess) {
      var successState = (state as SuccessTasksState);
      var models = successState.models.toList();
      models.removeWhere((element) => element.id == id);
      return Future.value(SuccessTasksState(models, false));
    } else {
      return Future.value(state);
    }
  }
}
