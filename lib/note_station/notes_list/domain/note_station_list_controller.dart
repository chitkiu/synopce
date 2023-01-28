import 'package:get/get.dart';

import '../../../common/data/api_service.dart';
import '../../../common/data/note_station_service/note_station_service.dart';
import '../ui/models/notes_item_ui_model.dart';
import 'mappers/notes_ui_model_mapper.dart';

class NoteStationListController extends GetxController {
  final NotesUiModelMapper _mapper = NotesUiModelMapper();

  NoteStationService get _nsService => Get.find<ApiService>().nsService;

  RxList<NotesItemUIModel> notesList = RxList.of([]);

  RxBool isLoading = true.obs;

  @override
  void onInit() async {
    await refreshItems();
    super.onInit();
  }

  Future<void> refreshItems() async {
    isLoading.value = true;
    notesList.value = _mapper.mapToUIModel(await _nsService.getNoteList());
    isLoading.value = false;
  }

}
