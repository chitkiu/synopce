import '../models/auth_data_model.dart';
import 'auth_service.dart';

class StubAuthService extends AuthService {

  final Function() _onAuth;

  StubAuthService(this._onAuth);

  @override
  Future<bool> logIn(AuthDataModel authModel) {
    _onAuth();
    return Future.value(true);
  }

  @override
  Future<bool> logInWithCookie(AuthDataModel authModel) {
    _onAuth();
    return Future.value(true);
  }

  @override
  Future<bool> logOut() {
    return Future.value(true);
  }

}