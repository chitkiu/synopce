import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:synoapi/synoapi.dart';

import '../auth/data/safe_storage.dart';
import '../download_station/tasks_list/data/tasks_info_provider.dart';
import '../download_station/tasks_list/data/tasks_info_repository.dart';
import '../download_station/tasks_list/data/tasks_info_storage.dart';

class SDK {
  late APIContext _context;
  late DownloadStationAPI dsSDK;
  late DownloadStation2API ds2SDK;
  late FileStationAPI fsSDK;
  late NoteStationAPI nsSDK;
  late Uri uri;
  final FlutterSecureStorage storage = const FlutterSecureStorage();
  late CookieJar cookieJar = PersistCookieJar(storage: SafeStorage(storage));
  late TasksInfoProvider provider;
  late TasksInfoRepository repository;

  Future<bool> init({
    required String url,
    required String username,
    required String password,
  }) {
    uri = Uri.parse(url);
    var context = APIContext.uri(url, cookieJar);
    return _baseInit(
        context,
        context.authApp(username, password)
    );
  }

  Future<bool> initWithCookies({
    required String url,
  }) {
    uri = Uri.parse(url);
    var context = APIContext.cookie(url, cookieJar);
    return _baseInit(
        context,
        context.authCookieApp()
    );
  }

  Future<bool> logout() {
    return _context.logout();
  }

  Future<bool> _baseInit(APIContext context, Future<bool> request) async {
    var localDsAPI = DownloadStationAPI(context);
    var localDs2API = DownloadStation2API(context);
    var localFsAPI = FileStationAPI(context);
    var localNsAPI = NoteStationAPI(context);
    return request
        .then((value) {
      if (value) {
        _context = context;
        dsSDK = localDsAPI;
        ds2SDK = localDs2API;
        fsSDK = localFsAPI;
        nsSDK = localNsAPI;
        provider = TasksInfoProvider(localDsAPI);
        repository = TasksInfoRepository(TasksInfoStorage(), provider);
      }
      return value;
    });
  }

  static final SDK instance = SDK._();

  SDK._();
}
