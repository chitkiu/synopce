class AuthUIModel {
  final String url;
  final String username;
  final bool isHttps;
  final bool needToAutologin;

  const AuthUIModel(
      {required this.url,
      required this.username,
      required this.isHttps,
      required this.needToAutologin});

  @override
  String toString() {
    return 'AuthDataModel{url: $url, username: $username, isHttps: $isHttps, needToAutologin: $needToAutologin}';
  }

  AuthUIModel copyWith({
    String? url,
    String? username,
    bool? isHttps,
    bool? needToAutologin,
  }) {
    return AuthUIModel(
      url: url ?? this.url,
      username: username ?? this.username,
      isHttps: isHttps ?? this.isHttps,
      needToAutologin: needToAutologin ?? this.needToAutologin,
    );
  }
}
