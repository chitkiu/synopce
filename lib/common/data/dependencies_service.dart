import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DependenciesService extends GetxService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
}

//TODO Maybe remove in future
extension DependenciesExtension on Object {
  DependenciesService get _dependenciesService => Get.find<DependenciesService>();
  FlutterSecureStorage get flutterSecureStorage => _dependenciesService.storage;
}

