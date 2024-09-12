import 'dart:async';

import 'package:assets_manager/services/db_authentic_api.dart';

class AuthenticationBloc {
  final AuthenticationApi authenticationApi;

  AuthenticationBloc(this.authenticationApi) {
    onAuthChanged();
  }

  final StreamController<String> _authenticationController =
      StreamController<String>();
  Sink<String> get addUser => _authenticationController.sink;
  Stream<String> get user => _authenticationController.stream;

  final StreamController<bool> _logoutController = StreamController<bool>();
  Sink<bool> get logoutUser => _logoutController.sink;
  Stream<bool> get listLogoutUser => _logoutController.stream;

  final StreamController<bool> _deleteController = StreamController<bool>();
  Sink<bool> get deleteUser => _deleteController.sink;
  Stream<bool> get listdeleteUser => _deleteController.stream;

  void dispose() {
    _logoutController.close();
    _authenticationController.close();
    _deleteController.close();
  }

  void onAuthChanged() {
    authenticationApi.getFirebaseAuth().authStateChanges().listen((user) {
      final String uid = user != null ? user.uid : "";
      addUser.add(uid);
    });
    _logoutController.stream.listen((logout) {
      if (logout = true) {
        _signOut();
      }
    });
  }

  void _signOut() {
    authenticationApi.signOut();
  }
}
