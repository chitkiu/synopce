import 'package:dsm_sdk/download_station/models/download_station_task_info_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'task_info_event.dart';
part 'task_info_state.dart';

class TaskInfoBloc extends Bloc<TaskInfoEvent, TaskInfoState> {
  TaskInfoBloc() : super(TaskInfoInitialState()) {
    on<ShowTaskInfoEvent>((event, emit) {
      emit(ShowTaskInfoState(event.task));
    });
  }
}
