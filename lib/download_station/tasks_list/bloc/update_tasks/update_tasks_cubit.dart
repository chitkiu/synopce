import 'dart:async';

import 'package:bloc/bloc.dart';

import 'update_tasks_state.dart';

class UpdateTasksCubit extends Cubit<RequestUpdateTasks> {
  Timer? timer;

  UpdateTasksCubit() : super(RequestUpdateTasks()) {
    startTimer();
  }

  void startTimer() {
    timer ??= Timer.periodic(const Duration(seconds: 3), (timer) {
        emit(RequestUpdateTasks());
      });
  }

  void stopTimer() {
    timer?.cancel();
  }

  @override
  Future<void> close() {
    stopTimer();
    return super.close();
  }
}
