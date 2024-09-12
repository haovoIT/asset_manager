import 'package:assets_manager/component/alert.dart';
import 'package:assets_manager/component/app_string.dart';
import 'package:assets_manager/services/db_authentic_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class AuthenticationServer implements AuthenticationApi {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final BuildContext context;

  AuthenticationServer(this.context);

  FirebaseAuth getFirebaseAuth() {
    return _firebaseAuth;
  }

  Future<void> signOut() async {
    return _firebaseAuth.signOut();
  }

  @override
  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    String mas = "";
    try {
      final response = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      print(response);
      return response;
    } catch (e) {
      if (e.toString().contains("firebase_auth/user-not-found")) {
        mas = CommonString.ERROR_USER_NOT_FOUND;
      } else if (e.toString().contains("firebase_auth/wrong-password")) {
        mas = CommonString.ERROR_WRONG_PASSWORD;
      } else {
        mas = CommonString.ERROR_MESSAGE;
      }
      Alert.showError(
        title: CommonString.ERROR,
        message: mas,
        buttonText: CommonString.CANCEL,
        context: context,
      );
    }
    return null;
  }

  @override
  Future<String?> createUserWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      Alert.showError(
          title: CommonString.ERROR,
          message: CommonString.ERROR_MESSAGE,
          buttonText: CommonString.CANCEL,
          context: context);
    }
    return null;
  }

  @override
  Future<String?> forgotpassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email).then((value) =>
          Alert.showSuccess(
              title: CommonString.SUCCESS,
              message: CommonString.EMAIL_MASSAGE,
              buttonText: CommonString.OK,
              context: context));
    } catch (e) {
      String mas = "";
      if (e.toString().contains("firebase_auth/unknown")) {
        mas = CommonString.ERROR_UNKNOWN;
      } else if (e.toString().contains("firebase_auth/user-not-found")) {
        mas = CommonString.ERROR_USER_NOT_FOUND;
      } else {
        mas = CommonString.ERROR_MESSAGE;
      }
      Alert.showError(
          title: CommonString.ERROR,
          message: mas,
          buttonText: CommonString.CANCEL,
          context: context);
    }
    return null;
  }

  @override
  Future<String?> updatePassword({required String newPassword}) async {
    try {
      await _firebaseAuth.currentUser!.updatePassword(newPassword).then(
          (value) => Alert.showSuccess(
              title: CommonString.SUCCESS,
              message: CommonString.EMAIL_MASSAGE,
              buttonText: CommonString.OK,
              context: context));
    } catch (e) {
      Alert.showError(
          title: CommonString.ERROR,
          message: CommonString.ERROR_MESSAGE,
          buttonText: CommonString.CANCEL,
          context: context);
    }
    return null;
  }
}
