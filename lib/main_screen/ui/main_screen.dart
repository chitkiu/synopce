import 'package:flutter/material.dart';
import 'package:flutter_platform_widgets/flutter_platform_widgets.dart';

import '../domain/models/main_screen_type.dart';
import 'main_screen_body_providers.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {

  final MainScreenBodyProviders _bodyProviders = MainScreenBodyProviders();

  MainScreenType _currentItem = MainScreenType.tasksList;

  //TODO Rewrite to platform specific widget
  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: _bodyProviders.provideBody(_currentItem),
        material: (context, platform) {
          return MaterialScaffoldData(
            bottomNavBar: NavigationBar(
              destinations: MainScreenType.values.map((e) => NavigationDestination(
                icon: Icon(e.icon),
                label: e.name,
              )).toList(),
              onDestinationSelected: (newIndex) {
                MainScreenType newItem = MainScreenType.values[newIndex];
                if (newItem != _currentItem) {
                  setState(() {
                    _currentItem = newItem;
                  });
                }
              },
              selectedIndex: _currentItem.index,
            )
          );
        },
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
}
