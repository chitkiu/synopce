

abstract class TaskInfoState {}

class TaskInfoInitialState extends TaskInfoState {}

class ShowTaskInfoState extends TaskInfoState {
  final String? taskId;

  ShowTaskInfoState(this.taskId);
}
