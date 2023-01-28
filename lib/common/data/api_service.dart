import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../download_station/tasks_list/data/tasks_info_repository.dart';
import '../../download_station/tasks_list/data/tasks_info_storage.dart';
import 'download_station_service/backend_download_station_service.dart';
import 'download_station_service/download_station_service.dart';
import 'file_station_service/backend_file_station_service.dart';
import 'file_station_service/file_station_service.dart';

class ApiService extends GetxService {

  late FileStationService fsService;
  late DownloadStationService dsService;

  //TODO Wrap with abstract class
  late NoteStationAPI nsSDK;
  late TasksInfoRepository repository;

  void init(APIContext context) {
    fsService = BackendFileStationService(context);
    dsService = BackendDownloadStationService(context);

    nsSDK = NoteStationAPI(context);
    repository = TasksInfoRepository(TasksInfoStorage(), dsService);
  }

}


//TODO Maybe remove in future
extension ApiExtension on Object {
  ApiService get _apiService => Get.find<ApiService>();

  FileStationService get fsService => _apiService.fsService;
  DownloadStationService get dsService => _apiService.dsService;
  NoteStationAPI get nsSDK => _apiService.nsSDK;
  TasksInfoRepository get repository => _apiService.repository;
}

