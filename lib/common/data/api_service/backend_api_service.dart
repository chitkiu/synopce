import 'package:synoapi/synoapi.dart';

import '../download_station_service/backend_download_station_service.dart';
import '../download_station_service/download_station_service.dart';
import '../file_station_service/backend_file_station_service.dart';
import '../file_station_service/file_station_service.dart';
import '../note_station_service/backend_note_station_service.dart';
import '../note_station_service/note_station_service.dart';
import 'api_service.dart';

class BackendApiService extends ApiService {

  BackendApiService(APIContext context):
        dsService = BackendDownloadStationService(context),
        fsService = BackendFileStationService(context),
        nsService = BackendNoteStationService(context),
        super();

  @override
  DownloadStationService dsService;

  @override
  FileStationService fsService;

  @override
  NoteStationService nsService;

}