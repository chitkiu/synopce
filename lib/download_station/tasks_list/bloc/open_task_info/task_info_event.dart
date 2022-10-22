import 'package:dsm_sdk/download_station/tasks/info/ds_task_info_model.dart';

abstract class TaskInfoEvent {}

class ShowTaskInfoEvent extends TaskInfoEvent {
  final TaskInfoDetailModel? task;

  ShowTaskInfoEvent(this.task);
}
