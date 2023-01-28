import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../../common/ui/icons_constants.dart';
import '../domain/tasks_info_controller.dart';
import 'tasks_error_widget.dart';
import 'tasks_list_widget.dart';

class TasksDataWidget extends GetView<TasksListController> {
  final Function(Task task) _onTaskSelected;
  final Widget Function() _selectedTaskWidget;

  const TasksDataWidget(this._onTaskSelected, this._selectedTaskWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var errorText = controller.errorText.value;
      if (errorText != null && errorText.isNotEmpty) {
        return TasksErrorWidget(errorText);
      }
      var tasks = controller.tasksModel.value?.values;
      if (tasks == null) {
        return _loadingWidget(context);
      }
      return TasksListWidget(tasks.toList(), _onTaskSelected, _selectedTaskWidget);
    });
  }

  Widget _loadingWidget(BuildContext context) {
    return Center(
      child: Align(
        alignment: Alignment.center,
        child: progressIcon(context, size: 60),
      ),
    );
  }
}
