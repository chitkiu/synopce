import 'models/data_result.dart';
import 'tasks_info_provider.dart';

class TasksRepository {
  final TasksInfoProvider tasksInfoProvider;

  TasksRepository(this.tasksInfoProvider);

  Future<Data> getData() async {
    var result = await tasksInfoProvider.getData();
    Data response;
    if (result.isSuccess) {
      response = Success(result.successValue.tasks);
    } else {
      response = Error(result.errorValue);
    }

    return Future.value(response);
  }

  Future<Data> removeItem(String id, Data state) async {
    var result = await tasksInfoProvider.removeItem(id);
    if (result.isSuccess && state.isSuccess) {
      var successState = (state as Success);
      var models = successState.models.toList();
      models.removeWhere((element) => element.id == id);
      return Future.value(Success(models));
    } else {
      return Future.value(state);
    }
  }
}
