part of 'task_info_bloc.dart';

abstract class TaskInfoState {}

class TaskInfoInitialState extends TaskInfoState {}

class ShowTaskInfoState extends TaskInfoState {
  final TaskInfoDetailModel? task;

  ShowTaskInfoState(this.task);
}
