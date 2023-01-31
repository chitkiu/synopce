import 'package:get/get.dart';

extension GetxExt on GetInterface {
  Future<void> deleteIfExist<T>({bool force = false}) {
    if (isRegistered<T>()) {
      return delete<T>(force: force);
    } else {
      return Future(() {});
    }
  }
}