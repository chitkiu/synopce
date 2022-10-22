import 'package:flutter_bloc/flutter_bloc.dart';

import 'task_info_event.dart';
import 'task_info_state.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  TaskInfoBloc() : super(TaskInfoInitialState()) {
    on<ShowTaskInfoEvent>((event, emit) {
      emit(ShowTaskInfoState(event.task?.id));
    });
  }
}
