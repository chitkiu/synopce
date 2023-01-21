import 'package:dsm_app/download_station/tasks_list/tasks_list_app_bar.dart';
import 'package:dsm_app/settings/settings_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import '../common/icons_constants.dart';
import '../download_station/task_info/task_info_widget.dart';
import '../download_station/tasks_list/data/tasks_info_controller.dart';
import '../download_station/tasks_list/tasks_data_widget.dart';
import '../sdk.dart';
import '../settings/settings_app_bar.dart';
import 'main_screen_type.dart';

class MainScreen extends StatefulWidget {
  final TasksListController _mainController =
      Get.put(TasksListController(SDK.instance.repository));

  MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  MainScreenType _selected = MainScreenType.tasksList;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
      appBar: _getAppBar(_selected),
      body: _getBody(_selected),
      material: (context, platform) => _getData(_selected),
      bottomNavBar: PlatformNavBar(
        currentIndex: _selected.index,
        itemChanged: (p0) {
          setState(() {
            _selected = MainScreenType.values[p0];
          });
        },
        items: MainScreenType.values.map((e) {
          return BottomNavigationBarItem(
            icon: Icon(e.icon),
            label: e.name,
          );
        }).toList(),
      ),
    );
  }

  MaterialScaffoldData _getData(MainScreenType type) {
    switch (type) {
      case MainScreenType.tasksList:
        return MaterialScaffoldData(
            floatingActionButton: FloatingActionButton(
          onPressed: () {
            TasksListController controller = Get.find();
            controller.onAddClick();
          },
          child: addIcon(context),
        ));
      case MainScreenType.settings:
        return MaterialScaffoldData();
    }
  }

  Widget _getBody(MainScreenType type) {
    switch (type) {
      case MainScreenType.tasksList:
        return _tasksListWidget(Get.find());
      case MainScreenType.settings:
        return const SettingsWidget();
    }
  }

  PlatformAppBar _getAppBar(MainScreenType type) {
    switch (type) {
      case MainScreenType.tasksList:
        return TasksListAppBar(Get.find());
      case MainScreenType.settings:
        return SettingsAppBar();
    }
  }

  Widget _tasksListWidget(TasksListController controller) {
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
