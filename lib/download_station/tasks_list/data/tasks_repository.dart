import '../bloc/tasks/tasks_state.dart';
import 'tasks_info_provider.dart';

class TasksRepository {
  final TasksInfoProvider tasksInfoProvider;

  TasksRepository(this.tasksInfoProvider);

  Future<TasksState> getData() async {
    var result = await tasksInfoProvider.getData();
    TasksState response;
    if (result.isSuccess) {
      response = SuccessTasksState(result.successValue.tasks);
    } else {
      response = ErrorTasksState(result.errorValue);
    }

    return Future.value(response);
  }

  Future<TasksState> removeItem(String id, TasksState state) async {
    var result = await tasksInfoProvider.removeItem(id);
    if (result.isSuccess && state.isSuccess) {
      var successState = (state as SuccessTasksState);
      var models = successState.models.toList();
      models.removeWhere((element) => element.id == id);
      return Future.value(SuccessTasksState(models));
    } else {
      return Future.value(state);
    }
  }
}
