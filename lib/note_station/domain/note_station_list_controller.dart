import 'package:get/get.dart';
import 'package:synopce/common/data/api_service.dart';
import 'package:synopce/common/data/note_station_service/note_station_service.dart';
import 'package:synopce/note_station/domain/mappers/notes_ui_model_mapper.dart';

import '../ui/models/notes_item_ui_model.dart';

class NoteStationListController extends GetxController {
  final NotesUiModelMapper _mapper = NotesUiModelMapper();

  NoteStationService get _nsService => Get.find<ApiService>().nsService;

  RxList<NotesItemUIModel> notesList = RxList.of([]);

  @override
  void onInit() async {
    await refreshItems();
    super.onInit();
  }

  Future<void> refreshItems() async {
    notesList.value = _mapper.mapToUIModel(await _nsService.getNoteList());
  }

}
