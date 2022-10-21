abstract class TasksEvent {
  TasksEvent._();
}

class LoadTasksEvent extends TasksEvent {
  LoadTasksEvent() : super._();
}

class DeleteTasksEvent extends TasksEvent {
  final String eventId;
  DeleteTasksEvent(this.eventId) : super._();
}
