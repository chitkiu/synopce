import 'package:get/get.dart';
import 'package:sentry_flutter/sentry_flutter.dart';
import 'package:synopce/common/data/models/api_error_exception.dart';

import '../../../common/data/api_service/api_service.dart';
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
    try {
      notesList.value = _mapper.mapToUIModel(await _nsService.getNoteList());
    } on ApiErrorException catch (e) {
      Sentry.captureException(e);
    }
    isLoading.value = false;
  }

}
