import 'package:flutter/foundation.dart';

@immutable
class LocalAuthDataModel {
  final String url;
  final String username;
  final bool isHttps;
  final bool needToAutologin;

  const LocalAuthDataModel(
      {required this.url,
      required this.username,
      required this.isHttps,
      required this.needToAutologin});

  LocalAuthDataModel copyWith({
    String? url,
    String? username,
    bool? isHttps,
    bool? needToAutologin,
  }) {
    return LocalAuthDataModel(
      url: url ?? this.url,
      username: username ?? this.username,
      isHttps: isHttps ?? this.isHttps,
      needToAutologin: needToAutologin ?? this.needToAutologin,
    );
  }
}
