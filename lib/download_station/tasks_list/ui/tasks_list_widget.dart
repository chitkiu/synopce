import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';

import '../../../common/ui/platform_list_view.dart';
import '../../task_info/ui/task_info_screen.dart';
import 'models/task_ui_model.dart';

class TasksListWidget extends StatelessWidget {
  final List<TaskUIModel> _tasks;
  final Function(TaskUIModel task) _onTaskSelected;
  final Widget Function() _selectedTaskWidget;

  const TasksListWidget(
      this._tasks,
      this._onTaskSelected,
      this._selectedTaskWidget,
      {Key? key}
      ) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScreenTypeLayout(
          mobile: _mobileWidget(_tasks),
          tablet: _desktopWidget(_tasks),
          desktop: _desktopWidget(_tasks),
    ));
  }

  Widget _mobileWidget(List<TaskUIModel> items) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (items.isEmpty)
            PlatformText("No items")
          else
            Expanded(
                child: _getItemsList(
              items,
              (task) {
                Get.to(() => TaskInfoScreen(task.id));
              },
            )),
        ],
      ),
    );
  }

  Widget _desktopWidget(List<TaskUIModel> items) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _getItemsList(
            items,
            _onTaskSelected,
          ),
        ),
        const VerticalDivider(),
        Expanded(
          child: _selectedTaskWidget(),
        )
      ],
    );
  }

  Widget _getItemsList(List<TaskUIModel> items, void Function(TaskUIModel task) onClick) {
    return PlatformListView<TaskUIModel>(
      items: items,
      onTap: (taskInfoDetailModel) {
        onClick(taskInfoDetailModel);
      },
      separatorBuilder: (BuildContext context, int index) => const Divider(),
    );
  }
}
