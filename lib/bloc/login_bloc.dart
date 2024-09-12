import 'dart:async';

import 'package:assets_manager/classes/validators.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/component/domain_service.dart';
import 'package:assets_manager/component/shared_preferences.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:flutter/material.dart';

class LoginBloc with SharedPreferencesManager {
  final AuthenticationApi authenticationApi;
  String? _name;
  String? _email;
  String? _password;
  bool? _emailValid;
  bool? _passwordValid;
  String? uid;
  String? forgotPassword;
  String? updatePass;
  final BuildContext context;

  LoginBloc({required this.authenticationApi, required this.context}) {
    _startListenersIfEmailPasswordAreValid();
  }

  final StreamController<String> _nameController =
      StreamController<String>.broadcast();
  Sink<String> get nameEditChanged => _nameController.sink;
  Stream<String> get nameEdit => _nameController.stream;

  final StreamController<String> _emailController =
      StreamController<String>.broadcast();
  Sink<String> get emailChanged => _emailController.sink;
  Stream<String> get email =>
      _emailController.stream.transform(Validators().validateEmail);

  final StreamController<String> _passwordController =
      StreamController<String>.broadcast();
  Sink<String> get passwordChanged => _passwordController.sink;
  Stream<String> get password =>
      _passwordController.stream.transform(Validators().validatePassword);

  final StreamController<bool> _enableLoginCreateButtonController =
      StreamController<bool>.broadcast();
  Sink<bool> get enableLoginCreateButtonChanged =>
      _enableLoginCreateButtonController.sink;
  Stream<bool> get enableLoginCreateButton =>
      _enableLoginCreateButtonController.stream;

  final StreamController<String> _loginOrCreateButtonController =
      StreamController<String>();
  Sink<String> get loginOrCreateButtonChanged =>
      _loginOrCreateButtonController.sink;
  Stream<String> get loginOrCreateButton =>
      _loginOrCreateButtonController.stream;

  final StreamController<String> _loginOrCreateController =
      StreamController<String>();
  Sink<String> get loginOrCreateChanged => _loginOrCreateController.sink;
  Stream<String> get loginOrCreate => _loginOrCreateController.stream;

  final StreamController<String> _emailsController =
      StreamController<String>.broadcast();
  Sink<String> get emailsEditChanged => _emailsController.sink;
  Stream<String> get emailsEdit =>
      _emailsController.stream.transform(Validators().validateEmail);

  final StreamController<String> _forgotPasswordController =
      StreamController<String>.broadcast();
  Sink<String> get forgotPasswordEditChanged => _forgotPasswordController.sink;
  Stream<String> get forgotPasswordEdit => _forgotPasswordController.stream;

  final StreamController<String> _updatePasswordController =
      StreamController<String>.broadcast();
  Sink<String> get updatePasswordEditChanged => _updatePasswordController.sink;
  Stream<String> get updatePasswordEdit => _updatePasswordController.stream;

  final StreamController<String> _updatePassController =
      StreamController<String>.broadcast();
  Sink<String> get updatePassEditChanged => _updatePassController.sink;
  Stream<String> get updatePassEdit => _updatePassController.stream;

  void dispose() {
    _nameController.close();
    _passwordController.close();
    _emailController.close();
    _emailsController.close();
    _enableLoginCreateButtonController.close();
    _loginOrCreateButtonController.close();
    _loginOrCreateController.close();
    _updatePasswordController.close();
    _forgotPasswordController.close();
    _updatePassController.close();
  }

  void _startListenersIfEmailPasswordAreValid() {
    _nameController.stream.listen((name) {
      _name = name;
    });
    email.listen((email) {
      _email = email;
      _emailValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _email = '';
      _emailValid = false;
      _updateEnableLoginCreateButtonStream();
    });

    password.listen((password) {
      _password = password;
      _passwordValid = true;
      _updateEnableLoginCreateButtonStream();
    }).onError((error) {
      _password = '';
      _passwordValid = false;
      _updateEnableLoginCreateButtonStream();
    });
    loginOrCreate.listen((action) {
      action == DomainProvider.ACT_LOGIN ? _logIn() : _createAccount();
    });
    _emailsController.stream.listen((email) {
      forgotPassword = email;
    });
    _forgotPasswordController.stream.listen((kp) {
      if (kp == DomainProvider.RESET) {
        _forgotPassword();
      }
    });
    _updatePassController.stream.listen((password) {
      updatePass = password;
    });
    _updatePasswordController.stream.listen((save) {
      if (save == DomainProvider.SAVE) {
        _updatePassword();
      }
    });
  }

  void _updateEnableLoginCreateButtonStream() {
    if (_emailValid == true && _passwordValid == true) {
      enableLoginCreateButtonChanged.add(true);
    } else {
      enableLoginCreateButtonChanged.add(false);
    }
  }

  Future<String> _logIn() async {
    String _result = '';
    if (_emailValid != null && _passwordValid != null) {
      await authenticationApi
          .signInWithEmailAndPassword(
              email: _email ?? "", password: _password ?? "")
          .then((user) async {
        print('Login_Bloc:/Đăng nhập thành công.');
        sharedPreferencesSave(SharedPreferencesKey.EMAIL, _email ?? "");
        sharedPreferencesSave(SharedPreferencesKey.PASSWORD, _password ?? "");
      }).catchError((error) {
        print('Login_Bloc:/Lỗi đăng nhập: $error');
        _result = error.toString();
      });
      return _result;
    } else {
      return AppString.EMPTY;
    }
  }

  Future<String> _createAccount() async {
    String _result = '';
    if (_emailValid! && _passwordValid!) {
      await authenticationApi
          .createUserWithEmailAndPassword(
              email: _email ?? "", password: _password ?? "")
          .then((user) {
        print('Login_Bloc:/Tạo tài khoản thành công.');
        _result = 'Created user: $user';
        _logIn();
      }).catchError((error) async {
        print('Login_Bloc:/Lỗi tạo tài khoản: $error');
      });
      return _result;
    } else {
      return AppString.EMPTY;
    }
  }

  Future<String?> _forgotPassword() async {
    await authenticationApi
        .forgotpassword(email: forgotPassword ?? "")
        .then((result) async {
      print('Login_Bloc:/Gửi email thành công.');
      return result;
    });
    return null;
  }

  Future<String?> _updatePassword() async {
    await authenticationApi
        .updatePassword(newPassword: updatePass ?? "")
        .then((result) async {
      print('Login_Bloc:/Cập nhật mật khẩu thành công.');
      return result;
    });
    return null;
  }
}
