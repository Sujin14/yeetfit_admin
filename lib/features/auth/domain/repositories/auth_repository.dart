import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  Future<UserCredential?> signInWithEmail(String email, String password);
  Future<UserCredential?> signUpWithEmail(
    String email,
    String password,
    String name, {
    File? profileImageFile,
  });
  Future<bool> isAdmin(String uid);
  Future<void> sendPasswordResetEmail(String email);
}