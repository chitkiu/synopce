import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

abstract class DeletableBindings extends Bindings {
  void delete();

  @protected
  void deleteIfExist<T>() {
    if (Get.isRegistered<T>()) {
      Get.delete<T>();
    }
  }
}