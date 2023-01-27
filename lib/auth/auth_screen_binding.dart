import 'package:get/get.dart';

import '../sdk.dart';
import 'auth_manager.dart';

class AuthScreenBinding extends Bindings {

  @override
  void dependencies() {
    Get.lazyPut(() => AuthManager(SDK.instance.storage));
  }
}