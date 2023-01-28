import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../../download_station/tasks_list/domain/tasks_info_binding.dart';
import '../../download_station/tasks_list/ui/tasks_info_page.dart';
import '../../note_station/ui/note_station_page.dart';
import '../../settings/ui/settings_page.dart';
import '../domain/models/main_screen_type.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  MainScreenType _currentItem = MainScreenType.tasksList;

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: _getBodyByType(_currentItem),
        bottomNavBar: PlatformNavBar(
          items: MainScreenType.values.map((e) => e.getNavBarItem()).toList(),
          currentIndex: _currentItem.index,
          itemChanged: (newIndex) {
            MainScreenType newItem = MainScreenType.values[newIndex];
            if (newItem != _currentItem) {
              setState(() {
                _currentItem = newItem;
              });
            }
          },
        )
    );
  }

  Widget _getBodyByType(MainScreenType type) {
    switch (type) {
      case MainScreenType.tasksList:
        TasksInfoBinding().dependencies();
        return const TasksInfoPage();
      case MainScreenType.noteStation:
        TasksInfoBinding().delete();
        return const NoteStationPage();
      case MainScreenType.settings:
        TasksInfoBinding().delete();
        return const SettingsPage();
    }
  }
}
