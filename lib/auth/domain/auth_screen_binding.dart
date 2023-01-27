import 'package:get/get.dart';
import 'package:synopce/auth/data/local_auth_data_storage.dart';

import 'auth_screen_controller.dart';

class AuthScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
        () => AuthScreenController(const LocalAuthDataStorage()));
  }
}
