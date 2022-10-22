import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

abstract class TaskInfoState {}

class TaskInfoInitialState extends TaskInfoState {}

class ShowTaskInfoState extends TaskInfoState {
  final TaskInfoDetailModel? task;

  ShowTaskInfoState(this.task);
}
