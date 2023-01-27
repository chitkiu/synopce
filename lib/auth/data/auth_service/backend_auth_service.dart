import 'package:get/get.dart';
import 'package:synoapi/synoapi.dart';
import 'package:synopce/common/data/dependencies_service.dart';

import '../../../common/data/file_station_service/backend_file_station_service.dart';
import '../../../common/data/file_station_service/file_station_service.dart';
import '../models/auth_data_model.dart';
import '../safe_storage.dart';
import 'auth_service.dart';

class BackendAuthService extends AuthService {

  APIContext? _context = null;

  final Function(APIContext) _onSuccessAuth;
  final Function() _onAuthFail;

  CookieJar get _cookieJar => PersistCookieJar(storage: SafeStorage(Get.find<DependenciesService>().storage));

  BackendAuthService(this._onSuccessAuth, this._onAuthFail);

  @override
  Future<bool> logIn(AuthDataModel authModel) {
    APIContext context = APIContext.uri(authModel.host, _cookieJar);

    return context.authApp(authModel.username ?? '', authModel.password ?? '')
        .then((value) {
      if (value) {
        _context = context;
        _onSuccessAuth(context);
      } else {
        _onAuthFail();
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

          _onAuthFail();
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
