import 'package:get/get.dart';

import '../download_station_service/download_station_service.dart';
import '../file_station_service/file_station_service.dart';
import '../note_station_service/note_station_service.dart';

abstract class ApiService extends GetxService {
  static ApiService get api => Get.find<ApiService>();

  abstract FileStationService fsService;
  abstract DownloadStationService dsService;
  abstract NoteStationService nsService;
}
