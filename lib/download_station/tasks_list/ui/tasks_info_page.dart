import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../../../common/sdk.dart';
import '../../../common/ui/icons_constants.dart';
import '../../task_info/ui/task_info_widget.dart';
import '../domain/tasks_info_controller.dart';
import 'tasks_data_widget.dart';
import 'tasks_list_app_bar.dart';

class TasksInfoPage extends GetView<TasksListController> {
  const TasksInfoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: TasksListAppBar(controller),
      body: _tasksListWidget(),
      material: (context, platform) {
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
          onPressed: () {
            controller.onAddClick();
          },
          child: addIcon(context),
        ));
      },
    );
  }

  Widget _tasksListWidget() {
    return TasksDataWidget(
      (task) {
        controller.selectedTaskModel.value = task.id;
      },
      () {
        String? taskId = controller.selectedTaskModel.value;
        if (taskId == null) {
          return _emptySelectedTask();
        }
        var task = SDK.instance.repository.tasks.value?[taskId];
        if (task == null) {
          return _emptySelectedTask();
        }
        return TaskInfoWidget(task);
      },
    );
  }

  Widget _emptySelectedTask() {
    return const Align(
      alignment: AlignmentDirectional.center,
      child: Text("Select item"),
    );
  }
}
