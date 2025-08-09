import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/theme.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/sign_up_with_email.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final isLoading = false.obs;

  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();

  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  final signUpNameController = TextEditingController();

  final showLoginPassword = false.obs;
  final showSignUpPassword = false.obs;
  final showSignUpConfirmPassword = false.obs;

  final signUpProfileImage = Rxn<File>();

  AuthController()
      : loginWithEmail = LoginWithEmail(
          AuthRepositoryImpl(emailService: EmailAuthService()),
        ),
        signUpWithEmail = SignUpWithEmail(
          AuthRepositoryImpl(emailService: EmailAuthService()),
        );

  Future<void> pickProfileImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (picked != null) {
      final file = File(picked.path);
      if (file.lengthSync() > 5 * 1024 * 1024) {
        Get.snackbar(
          'Error',
          'Image size exceeds 5MB limit',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
        return;
      }
      signUpProfileImage.value = file;
    }
  }

  Future<bool> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }
    isLoading.value = true;
    try {
      final success = await loginWithEmail(
        loginEmailController.text.trim(),
        loginPasswordController.text.trim(),
      );
      if (!success) {
        Get.snackbar(
          'Error',
          'Not an admin account or invalid credentials',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
        return false;
      }
      Get.offAllNamed('/home/dashboard');
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Login failed: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  Future<bool> signUp() async {
    if (!signUpFormKey.currentState!.validate()) {
      return false;
    }
    if (signUpPasswordController.text != signUpConfirmPasswordController.text) {
      Get.snackbar(
        'Error',
        'Passwords do not match',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }
    if (signUpPasswordController.text.trim().length < 6) {
      Get.snackbar(
        'Error',
        'Password must be at least 6 characters',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }

    isLoading.value = true;
    try {
      final success = await signUpWithEmail(
        signUpEmailController.text.trim(),
        signUpPasswordController.text.trim(),
        signUpNameController.text.trim(),
        profileImageFile: signUpProfileImage.value,
      );
      if (!success) {
        Get.snackbar(
          'Error',
          'Signup failed',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
        return false;
      }
      Get.offAllNamed('/home/dashboard');
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Signup failed: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  void toggleLoginPasswordVisibility() {
    showLoginPassword.value = !showLoginPassword.value;
  }

  void toggleSignUpPasswordVisibility() {
    showSignUpPassword.value = !showSignUpPassword.value;
  }

  void toggleSignUpConfirmPasswordVisibility() {
    showSignUpConfirmPassword.value = !showSignUpConfirmPassword.value;
  }

  void navigateToSignUp() => Get.toNamed('/signup');
  void navigateToLogin() => Get.toNamed('/');

  Future<bool> isAdmin(String uid) async {
    try {
      return await EmailAuthService().isAdmin(uid);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to check admin status: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }
  }

  Future<bool> logout() async {
    isLoading.value = true;
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAllNamed('/');
      return true;
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to log out: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpNameController.dispose();
    super.onClose();
  }
}