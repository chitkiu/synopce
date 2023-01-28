import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../common/domain/deletable_bindings.dart';
import '../../download_station/tasks_list/domain/tasks_info_binding.dart';
import '../../download_station/tasks_list/ui/tasks_info_page.dart';
import '../../note_station/ui/note_station_page.dart';
import '../../settings/ui/settings_page.dart';
import '../domain/models/main_screen_type.dart';

class MainScreenBodyProviders {
  final Map<MainScreenType, Bindings> _itemBindings = {
    MainScreenType.tasksList : TasksInfoBinding()
  };

  Widget provideBody(MainScreenType type) {
    _itemBindings[type]?.dependencies();
    for (var element in _itemBindings.entries) {
      if (element.key != type && element.value is DeletableBindings) {
        (element.value as DeletableBindings).delete();
      }
    }

    switch (type) {
      case MainScreenType.tasksList:
        return const TasksInfoPage();
      case MainScreenType.noteStation:
        return const NoteStationPage();
      case MainScreenType.settings:
        return const SettingsPage();
    }
  }

}