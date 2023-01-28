import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  @override
  Widget build(BuildContext context) {
    return PlatformScaffold(
        body: _bodyProviders.provideBody(_currentItem),
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
