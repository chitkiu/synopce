part of 'auth_bloc.dart';

abstract class AuthEvent {}

class LogInPressedAuthEvent extends AuthEvent {
  final String url;
  final String username;
  final String password;
  final bool isHttps;
  final bool needToAutologin;

  LogInPressedAuthEvent(
      {required this.url,
      required this.username,
      required this.password,
      required this.isHttps,
      required this.needToAutologin});
}
