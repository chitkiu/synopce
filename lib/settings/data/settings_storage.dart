import 'package:get/get.dart';

class SettingsStorage {

  var isUIFixForNotesEnabled = false.obs;

  static final SettingsStorage instance = SettingsStorage._();

  SettingsStorage._();
}