
import 'package:synoapi/synoapi.dart';

import 'file_station_service.dart';

class StubFileStationService extends FileStationService {
  @override
  Future<FileStationFolderFileList> listFolderFile(String path,
      {int? version, int offset = 0}) async {
    return FileStationFolderFileList(
        0,
        0,
        []
    );
  }

  @override
  Future<FileStationSharedFolderList> listSharedFolder(
      {int? version, int offset = 0}) {
    // TODO: implement listSharedFolder
    throw UnimplementedError();
  }
}
