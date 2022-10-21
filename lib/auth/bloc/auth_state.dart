part of 'auth_bloc.dart';

abstract class AuthState {}

class InitialAuthState extends AuthState {}

class UpdateDataAuthState extends AuthState {
  final String url;
  final String username;
  final String password;
  final bool isHttps;
  final bool needToAutologin;

  UpdateDataAuthState(
      {required this.url,
      required this.username,
      required this.password,
      required this.isHttps,
      required this.needToAutologin});
}

class LoadingAuthState extends AuthState {}

class ErrorAuthState extends AuthState {
  final String error;

  ErrorAuthState(this.error);
}

class SuccessLogInAuthState extends AuthState {}
