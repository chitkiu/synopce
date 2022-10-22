abstract class AuthState {}

class InitialAuthState extends AuthState {}

class DataAuthState extends AuthState {
  final String url;
  final String username;
  final String password;
  final bool isHttps;
  final bool needToAutologin;
  final bool hidePassword;
  final String? error;
  final InternalAuthState? state;

  DataAuthState(
      {this.url = "",
      this.username = "",
      this.password = "",
      this.isHttps = false,
      this.needToAutologin = false,
      this.hidePassword = true,
      this.error,
      this.state});

  @override
  String toString() {
    return 'DataAuthState{url: $url, username: $username, password: $password, isHttps: $isHttps, needToAutologin: $needToAutologin, hidePassword: $hidePassword, error: $error, state: $state}';
  }

  DataAuthState copyWith(
      {String? url,
      String? username,
      String? password,
      bool? isHttps,
      bool? needToAutologin,
      bool? hidePassword,
      String? error,
      InternalAuthState? state}) {
    return DataAuthState(
      url: url ?? this.url,
      username: username ?? this.username,
      password: password ?? this.password,
      isHttps: isHttps ?? this.isHttps,
      needToAutologin: needToAutologin ?? this.needToAutologin,
      hidePassword: hidePassword ?? this.hidePassword,
      error: error ?? this.error,
      state: state ?? this.state,
    );
  }
}

enum InternalAuthState {
  LOADING,
  SUCCESS;
}
