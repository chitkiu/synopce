import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/icons_constants.dart';
import 'data/tasks_info_controller.dart';
import 'tasks_error_widget.dart';
import 'tasks_list_widget.dart';

class TasksDataWidget extends StatelessWidget {
  final TasksListController _controller = Get.find();
  final Function(Task task) _onTaskSelected;
  final Widget Function() _selectedTaskWidget;

  TasksDataWidget(this._onTaskSelected, this._selectedTaskWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      var errorText = _controller.errorText.value;
      if (errorText != null && errorText.isNotEmpty) {
        return TasksErrorWidget(errorText);
      }
      var tasks = _controller.tasksModel.value?.values;
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
