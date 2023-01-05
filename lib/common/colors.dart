import 'package:flutter/material.dart';

Color getDividerColor() {
  Brightness brightness = WidgetsBinding.instance.window.platformBrightness;

  if (brightness == Brightness.light) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}
