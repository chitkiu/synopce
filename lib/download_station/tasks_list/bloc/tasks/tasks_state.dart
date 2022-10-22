import 'package:dsm_sdk/core/models/error_type.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

abstract class TasksState {
  const TasksState._();

  bool get isSuccess => this is SuccessTasksState;
}

class SuccessTasksState extends TasksState {
  final Iterable<TaskInfoDetailModel> models;

  SuccessTasksState(this.models) : super._();
}

class ErrorTasksState extends TasksState {
  final ErrorType errorType;

  ErrorTasksState(this.errorType) : super._();
}

class LoadingTasksState extends TasksState {
  LoadingTasksState() : super._();
}
