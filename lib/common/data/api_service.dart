import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import 'download_station_service/backend_download_station_service.dart';
import 'download_station_service/download_station_service.dart';
import 'download_station_service/stub_download_station_service.dart';
import 'file_station_service/backend_file_station_service.dart';
import 'file_station_service/file_station_service.dart';
import 'file_station_service/stub_file_station_service.dart';
import 'note_station_service/backend_note_station_service.dart';
import 'note_station_service/note_station_service.dart';
import 'note_station_service/stub_note_station_service.dart';

class ApiService extends GetxService {

  late FileStationService fsService;
  late DownloadStationService dsService;
  late NoteStationService nsService;

  void init(APIContext context) {
    fsService = BackendFileStationService(context);
    dsService = BackendDownloadStationService(context);
    nsService = BackendNoteStationService(context);
  }

  void stubInit() {
    fsService = StubFileStationService();
    dsService = StubDownloadStationService();
    nsService = StubNoteStationService();
  }

}


//TODO Maybe remove in future
extension ApiExtension on Object {
  ApiService get _apiService => Get.find<ApiService>();

  FileStationService get fsService => _apiService.fsService;
  DownloadStationService get dsService => _apiService.dsService;
  NoteStationService get nsService => _apiService.nsService;
}

