import 'package:flutter/material.dart';
import 'package:get/get.dart';

void errorSnackbar(String errorText) {
  Get.snackbar("Error", errorText, backgroundColor: Colors.redAccent);
}
