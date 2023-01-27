import 'package:get/get.dart';

import '../../common/sdk.dart';
import 'auth_screen_controller.dart';

class AuthScreenBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => AuthScreenController(SDK.instance.storage));
  }
}