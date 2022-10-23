import 'dart:developer';

import 'package:dsm_app/download_station/tasks_list/bloc/tasks/tasks_state.dart';
import 'package:dsm_sdk/core/models/error_type.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/tasks_repository.dart';
import 'tasks_events.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  TasksBloc(this.repository) : super(LoadingTasksState()) {
    on<LoadTasksEvent>(_onLoadEvent);
    on<DeleteTasksEvent>(_onDeleteEvent);
  }

  _onLoadEvent(LoadTasksEvent event, Emitter<TasksState> emit) async {
    try {
      emit(await repository.getData());
    } catch (error) {
      log(error.toString());
      emit(ErrorTasksState(ErrorType.UNKNOWN));
    }
  }

  _onDeleteEvent(DeleteTasksEvent event, Emitter<TasksState> emit) async {
    emit(await repository.removeItem(event.eventId, state));
  }

  final TasksRepository repository;
}
