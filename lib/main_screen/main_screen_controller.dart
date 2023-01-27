import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

import '../app_route_type.dart';
import 'main_screen_router_generation.dart';
import 'main_screen_type.dart';

class MainScreenController extends GetxController {
  final MainScreenRouterGeneration _mainScreenRouterGeneration = MainScreenRouterGeneration();

  var currentScreen = MainScreenType.tasksList.obs;

  void changePage(MainScreenType screenType) {
    currentScreen.value = screenType;
    // Get.offAllNamed(screenType.route, id: 1);
    Get.offNamedUntil(
      screenType.route,
      (page) => page.settings.name == AppRouteType.main.route,
      id: 1,
    );
  }

  Route? onGenerateRoute(RouteSettings settings) {
    return _mainScreenRouterGeneration.getRoute(settings);
  }
}