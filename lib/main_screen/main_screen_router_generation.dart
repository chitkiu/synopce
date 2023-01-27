import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../download_station/tasks_list/data/tasks_info_binding.dart';
import '../download_station/tasks_list/tasks_info_page.dart';
import '../note_station/note_station_page.dart';
import '../settings/settings_page.dart';
import 'main_screen_type.dart';

class MainScreenRouterGeneration {
  Route? getRoute(RouteSettings settings) {
    final String? name = settings.name;
    if (name == MainScreenType.tasksList.route) {
      return GetPageRoute(
        settings: settings,
        page: () => const TasksInfoPage(),
        binding: TasksInfoBinding(),
      );
    } else if (name == MainScreenType.noteStation.route) {
      return GetPageRoute(
        settings: settings,
        page: () => const NoteStationPage(),
        // binding: BrowseBinding(), TODO
      );
    } else if (name == MainScreenType.settings.route) {
      return GetPageRoute(
        settings: settings,
        page: () => const SettingsPage(),
        // binding: BrowseBinding(), TODO
      );
    }

    return null;
  }
}
