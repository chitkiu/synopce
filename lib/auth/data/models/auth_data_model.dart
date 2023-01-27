import 'package:flutter/foundation.dart';

@immutable
class AuthDataModel {
  final String host;
  final String? username;
  final String? password;

  const AuthDataModel(this.host, this.username, this.password);
}