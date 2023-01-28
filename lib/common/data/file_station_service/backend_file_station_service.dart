import 'package:synoapi/synoapi.dart';

import '../api_response_wrapper.dart';
import 'file_station_service.dart';

class BackendFileStationService extends FileStationService {

  final FileStationAPI _api;

  BackendFileStationService(APIContext context) : _api = FileStationAPI(context);

  @override
  Future<FileStationFolderFileList> listFolderFile(String path, {int? version, int offset = 0}) {
    return wrapRequest(_api.list.listFolderFile(path, offset: offset, version: version));
  }

  @override
  Future<FileStationSharedFolderList> listSharedFolder({int? version, int offset = 0}) {
    return wrapRequest(_api.list.listSharedFolder(offset: offset, version: version));
  }

}