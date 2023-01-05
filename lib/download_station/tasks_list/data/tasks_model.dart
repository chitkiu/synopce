import 'package:synoapi/synoapi.dart';

abstract class TasksModel {
  final bool isLoading;

  const TasksModel._(this.isLoading);
}

class SuccessTasksModel extends TasksModel {
  final List<Task> models;

  SuccessTasksModel(this.models, bool isLoading) : super._(isLoading);
}

class ErrorTasksModel extends TasksModel {
  final Map<String, dynamic> errorType;

  ErrorTasksModel(this.errorType, bool isLoading) : super._(isLoading);
}
