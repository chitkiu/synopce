import 'package:flutter/material.dart';
import 'package:get/get.dart';

Color getDividerColor() {
  return getBaseColor();
}

Color getBaseColor() {
  if (Get.isDarkMode) {
    return Colors.black;
  } else {
    return Colors.white;
  }
}
