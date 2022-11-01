abstract class TaskInfoModel {}

class GroupedTaskInfoModel extends TaskInfoModel {
  final String title;
  final List<TaskInfoDataModel> items;

  GroupedTaskInfoModel({required this.title, required this.items});
}

enum ActionTaskInfoType {
  RESUME,
  PAUSE,
  DELETE;
}

class ActionTaskInfoModel extends TaskInfoModel {
  final String title;
  final ActionTaskInfoType type;
  final String id;

  ActionTaskInfoModel({required this.title, required this.type, required this.id});
}

class TaskInfoDataModel {
  final String title;
  final String text;

  TaskInfoDataModel({required this.title, required this.text});
}
