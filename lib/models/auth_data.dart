import 'dart:io';

enum AuthMode {
  LOGIN,
  SIGNUP,
}

class AuthData {
  String? name;
  String? email;
  String? password;
  File? image;
  AuthMode _mode = AuthMode.LOGIN;

  void toogleMode() {
    _mode = _mode == AuthMode.LOGIN ? AuthMode.SIGNUP : AuthMode.LOGIN;
  }

  bool get isSignup => _mode == AuthMode.SIGNUP;
  bool get isLogin => _mode == AuthMode.LOGIN;
}
