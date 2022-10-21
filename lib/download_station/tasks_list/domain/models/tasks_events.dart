abstract class TasksEvent {
  TasksEvent._();
}

class LoadEvents extends TasksEvent {
  LoadEvents() : super._();
}

class DeleteEvent extends TasksEvent {
  final String eventId;
  DeleteEvent(this.eventId) : super._();
}

class SelectEvent extends TasksEvent {
  final String eventId;
  SelectEvent(this.eventId) : super._();
}
