import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import '../../download_station/tasks_list/data/tasks_info_provider.dart';
import '../../download_station/tasks_list/data/tasks_info_repository.dart';
import '../../download_station/tasks_list/data/tasks_info_storage.dart';
import 'file_station_service/backend_file_station_service.dart';
import 'file_station_service/file_station_service.dart';

class ApiService extends GetxService {

  late FileStationService fsService;

  //TODO Wrap with abstract class
  late DownloadStationAPI dsSDK;
  late DownloadStation2API ds2SDK;
  late NoteStationAPI nsSDK;
  late TasksInfoProvider provider;
  late TasksInfoRepository repository;

  void init(APIContext context) {
    fsService = BackendFileStationService(context);

    dsSDK = DownloadStationAPI(context);
    ds2SDK = DownloadStation2API(context);
    nsSDK = NoteStationAPI(context);
    provider = TasksInfoProvider(dsSDK);
    repository = TasksInfoRepository(TasksInfoStorage(), provider);
  }

}


//TODO Maybe remove in future
extension ApiExtension on Object {
  ApiService get _apiService => Get.find<ApiService>();

  FileStationService get fsService => _apiService.fsService;
  DownloadStationAPI get dsSDK => _apiService.dsSDK;
  DownloadStation2API get ds2SDK => _apiService.ds2SDK;
  NoteStationAPI get nsSDK => _apiService.nsSDK;
  TasksInfoProvider get provider => _apiService.provider;
  TasksInfoRepository get repository => _apiService.repository;
}

