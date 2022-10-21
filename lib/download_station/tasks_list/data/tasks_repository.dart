import 'models/data_result.dart';
import 'tasks_info_provider.dart';

class TasksRepository {
  final TasksInfoProvider tasksInfoProvider;
  String? _selectedId;

  TasksRepository(this.tasksInfoProvider);

  Future<Data> getData() async {
    var result = await tasksInfoProvider.getData();
    Data response;
    if (result.isSuccess) {
      response =
          Success(result.successValue.tasks, selectedTaskId: _selectedId);
    } else {
      response = Error(result.errorValue);
    }

    return Future.value(response);
  }

  Data selectItem(String? id, Data state) {
    _selectedId = id;
    if (state.isSuccess) {
      var successState = (state as Success);
      return Success(successState.models, selectedTaskId: id);
    } else {
      return state;
    }
  }

  Future<Data> removeItem(String id, Data state) async {
    var result = await tasksInfoProvider.removeItem(id);
    if (result.isSuccess && state.isSuccess) {
      var successState = (state as Success);
      var models = state.models.toList();
      models.removeWhere((element) => element.id == id);
      return Future.value(Success(models,
          selectedTaskId: (successState.selectedTaskId == id
              ? null
              : successState.selectedTaskId)));
    } else {
      return Future.value(state);
    }
  }
}
