import 'package:synoapi/synoapi.dart';

abstract class FileStationService {
  Future<FileStationSharedFolderList> listSharedFolder(
      {int? version,
        int offset = 0});

  Future<FileStationFolderFileList> listFolderFile(
      String path,
      {int? version,
        int offset = 0});
}