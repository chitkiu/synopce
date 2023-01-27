import 'package:synopce/auth/data/models/local_auth_data_model.dart';
import 'package:synopce/auth/ui/models/auth_ui_model.dart';

class LocalAuthDataMapper {
  AuthUIModel mapToUIModel(LocalAuthDataModel model) {
    return AuthUIModel(
      isHttps: model.isHttps,
      needToAutologin: model.needToAutologin,
      url: model.url,
      username: model.username,
    );
  }
}