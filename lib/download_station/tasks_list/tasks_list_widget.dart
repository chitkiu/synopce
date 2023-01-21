import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:synoapi/synoapi.dart';

import '../../common/colors.dart';
import '../task_info/task_info_screen.dart';
import 'task_item_widget.dart';

class TasksListWidget extends StatelessWidget {
  final List<Task> _tasks;
  final Function(Task task) _onTaskSelected;
  final Widget Function() _selectedTaskWidget;

  const TasksListWidget(this._tasks, this._onTaskSelected, this._selectedTaskWidget, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: ScreenTypeLayout(
          mobile: _mobileWidget(_tasks),
          tablet: _desktopWidget(_tasks),
          desktop: _desktopWidget(_tasks),
        )
    );
  }

  Widget _mobileWidget(List<Task> items) {
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

  Widget _desktopWidget(List<Task> items) {
    return Row(
      children: [
        SizedBox(
          width: 300,
          child: _getItemsList(
            items,
            _onTaskSelected,
          ),
        ),
        Container(width: 0.5, color: getDividerColor()),
        Expanded(
          child: _selectedTaskWidget(),
        )
      ],
    );
  }

  Widget _getItemsList(List<Task> items, void Function(Task task) onClick) {
    return ListView.separated(
      itemCount: items.length,
      itemBuilder: (BuildContext context, int index) {
        var taskInfoDetailModel = items[index];
        return GestureDetector(
          onTap: () {
            onClick(taskInfoDetailModel);
          },
          child: Align(
            alignment: AlignmentDirectional.center,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TaskItemWidget(taskInfoDetailModel),
            ),
          ),
        );
      },
      separatorBuilder: (BuildContext context, int index) =>
          Divider(color: getDividerColor()),
    );
  }
}
