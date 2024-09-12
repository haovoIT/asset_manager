import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthenticationApi {
  getFirebaseAuth();
  Future<void> signOut();
  Future<UserCredential?> signInWithEmailAndPassword(
      {required String email, required String password});
  Future<String?> createUserWithEmailAndPassword(
      {required String email, required String password});
  Future<String?> forgotpassword({required String email});
  //Future<void> sendEmailVerification();
  //Future<bool> isEmailVerified();
  //Future<String> updateProfile({String name});
  Future<String?> updatePassword({required String newPassword});
  //Future<String> delete();
}
