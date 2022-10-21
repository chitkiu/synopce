part of 'task_info_bloc.dart';

abstract class TaskInfoEvent {}

class ShowTaskInfoEvent extends TaskInfoEvent {
  final TaskInfoDetailModel? task;

  ShowTaskInfoEvent(this.task);
}
