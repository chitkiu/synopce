import 'package:get/get.dart';

import '../models/auth_data_model.dart';

abstract class AuthService extends GetxService {

  Future<bool> logIn(AuthDataModel authModel);

  Future<bool> logInWithCookie(AuthDataModel authModel);

  Future<bool> logOut();

}