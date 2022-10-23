import 'dart:async';

import 'package:bloc/bloc.dart';

import 'update_tasks_state.dart';

class UpdateTasksCubit extends Cubit<RequestUpdateTasks> {
  Timer? timer;

  UpdateTasksCubit() : super(RequestUpdateTasks()) {
    timer = Timer.periodic(const Duration(seconds: 3), (timer) {
      emit(RequestUpdateTasks());
    });
  }

  @override
  Future<void> close() {
    timer?.cancel();
    return super.close();
  }
}
