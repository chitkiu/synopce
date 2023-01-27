import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';
import 'package:get/get.dart';

import 'main_screen_controller.dart';
import 'main_screen_type.dart';

class MainScreen extends GetView<MainScreenController> {

  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return PlatformScaffold(
          body: Navigator(
            key: Get.nestedKey(1),
            initialRoute: controller.currentScreen.value.route,
            onGenerateRoute: controller.onGenerateRoute,
          ),
          bottomNavBar: PlatformNavBar(
            items: MainScreenType.values.map((e) => e.getNavBarItem()).toList(),
            currentIndex: controller.currentScreen.value.index,
            itemChanged: (newIndex) {
              MainScreenType newItem = MainScreenType.values[newIndex];
              if (newItem != controller.currentScreen.value) {
                controller.changePage(newItem);
              }
            },
          )
      );
    });
  }

}
