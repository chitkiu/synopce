import 'package:get/get.dart';

import '../../../common/domain/deletable_bindings.dart';
import 'note_station_list_controller.dart';

class NoteStationListBinding extends DeletableBindings {
  @override
  void delete() {
    deleteIfExist<NoteStationListController>();
  }

  @override
  void dependencies() {
    Get.lazyPut(() => NoteStationListController());
  }

}