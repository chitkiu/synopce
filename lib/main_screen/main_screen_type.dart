import 'package:flutter/material.dart';

//TODO Make icon platform-based
enum MainScreenType {
  tasksList("Tasks", Icons.cloud_download),
  settings("Settings", Icons.settings);

 final IconData icon;
 final String name;
 const MainScreenType(this.name, this.icon);
}
