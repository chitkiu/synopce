import 'package:synoapi/synoapi.dart';

abstract class TaskInfoEvent {}

class ShowTaskInfoEvent extends TaskInfoEvent {
  final Task? task;

  ShowTaskInfoEvent(this.task);
}
