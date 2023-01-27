import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get/get.dart';

class DependenciesService extends GetxService {
  final FlutterSecureStorage storage = const FlutterSecureStorage();
}