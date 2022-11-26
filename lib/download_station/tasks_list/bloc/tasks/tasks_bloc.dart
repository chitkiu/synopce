import 'dart:developer';

import 'package:dsm_app/download_station/tasks_list/bloc/tasks/tasks_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/tasks_repository.dart';
import 'tasks_events.dart';

class TasksBloc extends Bloc<TasksEvent, TasksState> {
  final TasksRepository repository;

  TasksBloc(this.repository) : super(LoadingTasksState()) {
    on<LoadTasksEvent>(_onLoadEvent);
    on<DeleteTasksEvent>(_onDeleteEvent);
  }

  _onLoadEvent(LoadTasksEvent event, Emitter<TasksState> emit) async {
    _reemitWithNewLoadingState(state, true);
    try {
      emit(await repository.getData());
    } catch (error) {
      log(error.toString());
      emit(ErrorTasksState({}, false));
    }
  }

  _onDeleteEvent(DeleteTasksEvent event, Emitter<TasksState> emit) async {
    emit(await repository.removeItem(event.eventId, state));
  }

  void _reemitWithNewLoadingState(TasksState state, bool isLoading) {
    if (state is SuccessTasksState) {
      emit(state.copyWith(isLoading: isLoading));
    } else if (state is ErrorTasksState) {
      emit(state.copyWith(isLoading: isLoading));
    }
  }

}
