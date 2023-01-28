import 'package:flutter/material.dart';

//TODO Make icon platform-based
enum MainScreenType {
  tasksList(r"Tasks", r"/tasks", Icons.cloud_download),
  noteStation(r"Notes", r"/notes", Icons.note),
  settings(r"Settings", r"/settings", Icons.settings);

 final IconData icon;
 final String name;
 final String route;
 const MainScreenType(this.name, this.route, this.icon);
}

extension MainScreenTypeExt on MainScreenType {
  BottomNavigationBarItem getNavBarItem() {
    return BottomNavigationBarItem(
      icon: Icon(icon),
      label: name,
    );
  }
}
