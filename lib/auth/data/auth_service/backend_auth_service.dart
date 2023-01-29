import 'package:synoapi/synoapi.dart';

import '../../../common/data/dependencies_service.dart';
import '../../../common/data/file_station_service/backend_file_station_service.dart';
import '../../../common/data/file_station_service/file_station_service.dart';
import '../models/auth_data_model.dart';
import '../safe_storage.dart';
import 'auth_service.dart';

class BackendAuthService extends AuthService {

  APIContext? _context;

  final Function(APIContext) _onSuccessAuth;

  CookieJar get _cookieJar => PersistCookieJar(storage: SafeStorage(flutterSecureStorage));

  BackendAuthService(this._onSuccessAuth);

  @override
  Future<bool> logIn(AuthDataModel authModel) {
    APIContext context = APIContext.uri(authModel.host, _cookieJar);

    return context.authApp(authModel.username ?? '', authModel.password ?? '')
        .then((value) {
      if (value) {
        _context = context;
        _onSuccessAuth(context);
      }
      return Future.value(value);
    });
  }

  @override
  Future<bool> logInWithCookie(AuthDataModel authModel) {
    APIContext context = APIContext.cookie(authModel.host, _cookieJar);

    return context.authCookieApp()
        .then((value) async {
          if (value) {
            FileStationService fsService = BackendFileStationService(context);
            try {
              //TODO Find and replace to better endpoint
              await fsService.listSharedFolder();
              _context = context;
              _onSuccessAuth(context);
              return true;
            } on Exception {
              //Do nothing
            }
          }

          return false;
    });
  }

  @override
  Future<bool> logOut() {
    return _context?.logout().then((value) {
      if (value) {
        _context = null;
      }
      return Future.value(value);
    }) ?? Future.value(true);
  }
}
