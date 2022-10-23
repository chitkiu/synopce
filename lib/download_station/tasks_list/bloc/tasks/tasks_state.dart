import 'package:dsm_sdk/core/models/error_type.dart';
import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

abstract class TasksState {
  final bool isLoading;
  const TasksState._(this.isLoading);

  bool get isSuccess => this is SuccessTasksState;
}

class SuccessTasksState extends TasksState {
  final Iterable<TaskInfoDetailModel> models;

  SuccessTasksState(this.models, bool isLoading) : super._(isLoading);

  SuccessTasksState copyWith({bool? isLoading}) {
    return SuccessTasksState(
      models,
      isLoading ?? this.isLoading
    );
  }

}

class ErrorTasksState extends TasksState {
  final ErrorType errorType;

  ErrorTasksState(this.errorType, bool isLoading) : super._(isLoading);

  ErrorTasksState copyWith({bool? isLoading}) {
    return ErrorTasksState(
        errorType,
        isLoading ?? this.isLoading
    );
  }
}

class LoadingTasksState extends TasksState {
  LoadingTasksState() : super._(false);
}
