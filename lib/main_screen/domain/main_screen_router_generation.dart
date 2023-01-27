import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../../download_station/tasks_list/domain/tasks_info_binding.dart';
import '../../download_station/tasks_list/ui/tasks_info_page.dart';
import '../../note_station/ui/note_station_page.dart';
import '../../settings/ui/settings_page.dart';
import 'models/main_screen_type.dart';

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
