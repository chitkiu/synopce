import '../download_station_service/download_station_service.dart';
import '../download_station_service/stub_download_station_service.dart';
import '../file_station_service/file_station_service.dart';
import '../file_station_service/stub_file_station_service.dart';
import '../note_station_service/note_station_service.dart';
import '../note_station_service/stub_note_station_service.dart';
import 'api_service.dart';

class StubApiService extends ApiService {

  StubApiService():
        dsService = StubDownloadStationService(),
        fsService = StubFileStationService(),
        nsService = StubNoteStationService(),
        super();

  @override
  DownloadStationService dsService;

  @override
  FileStationService fsService;

  @override
  NoteStationService nsService;

}