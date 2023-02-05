import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';

import 'file_station_service.dart';

class _Dir {
  final String path;
  final String name;
  final List<_Dir> items;

  const _Dir({required this.path, required this.name, this.items = const []});

  @override
  String toString() {
    return '_Dir{path: $path, name: $name}';
  }

  FileStationDirectory toDirectory() {
    return FileStationDirectory(
      name: name,
      path: path,
      isDir: true,
    );
  }
}

const List<_Dir> _dirs = [
  _Dir(name: "home", path: "home",),
  _Dir(name: "Downloads", path: "downloads",),
  _Dir(name: "media", path: "media", items: [
    _Dir(path: "media/Films", name: "Films",),
    _Dir(path: "media/serials", name: "Serials", items: [
      _Dir(path: 'media/serials/new_serial_1', name: 'First serial'),
      _Dir(path: 'media/serials/new_serial_2', name: 'Second serial', items: [
        _Dir(path: 'media/serials/new_serial_2/1_season', name: 'Second serial first season'),
        _Dir(path: 'media/serials/new_serial_2/2_season', name: 'Second serial second season'),
      ]),
    ]),
  ]),
];

class StubFileStationService extends FileStationService {
  late final List<_Dir> _allDirsForSearch;

  StubFileStationService() {
    _allDirsForSearch = _getAllDirs();
  }

  @override
  Future<FileStationFolderFileList> listFolderFile(String path,
      {int? version, int offset = 0}) async {
    _Dir? selectedDir =
        _allDirsForSearch.firstWhereOrNull((element) => element.path == path);
    return FileStationFolderFileList(
        offset: 0,
        total: 0,
        files: selectedDir?.items.map((e) => e.toDirectory()).toList() ?? []
    );
  }

  @override
  Future<FileStationSharedFolderList> listSharedFolder(
      {int? version, int offset = 0}) async {
    return FileStationSharedFolderList(
        total: 0,
        offset: 0,
        shares: _dirs.map((e) => e.toDirectory()).toList()
    );
  }

  List<_Dir> _getAllDirs() {
    List<_Dir> resultList = [];
    resultList.addAll(_dirs);
    for (var value in _dirs) {
      resultList.addAll(_getDirsAndSubdirs(value));
    }
    return resultList;
  }

  List<_Dir> _getDirsAndSubdirs(_Dir first) {
    List<_Dir> resultList = [];
    resultList.addAll(first.items);
    if (resultList.isNotEmpty) {
      List<_Dir> localResult = [];
      for (var value in resultList) {
        localResult.addAll(_getDirsAndSubdirs(value));
      }
      resultList.addAll(localResult);
    }
    return resultList;
  }
}
