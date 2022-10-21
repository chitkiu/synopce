import 'package:dsm_sdk/core/models/error_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../data/models/data_result.dart';
import '../data/tasks_repository.dart';
import 'models/tasks_events.dart';

class TasksBLoC extends Bloc<TasksEvent, Data> {
  TasksBLoC(this.repository) : super(Loading()) {
    on<LoadEvents>(_onLoadEvent);
    on<DeleteEvent>(_onDeleteEvent);
    on<SelectEvent>(_onSelectEvent);
  }

  _onLoadEvent(LoadEvents event, Emitter<Data> emit) async {
    try {
      emit(await repository.getData());
    } catch (error) {
      emit(Error(ErrorType.UNKNOWN));
    }
  }

  _onDeleteEvent(DeleteEvent event, Emitter<Data> emit) async {
    emit(await repository.removeItem(event.eventId, state));
  }

  _onSelectEvent(SelectEvent event, Emitter<Data> emit) {
    emit(repository.selectItem(event.eventId, state));
  }

  final TasksRepository repository;
}
