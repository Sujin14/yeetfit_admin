// path: lib/features/auth/presentation/controllers/auth_controller.dart
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
import '../../domain/usecases/send_password_reset_email.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final SendPasswordResetEmail resetPasswordUseCase;
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
        ),
        resetPasswordUseCase = SendPasswordResetEmail(
          AuthRepositoryImpl(emailService: EmailAuthService()),
        );

  /// Clears controllers and temporary image. Call this when logging out
  /// or when navigating to auth screens so previous credentials aren't visible.
  void clearAuthFields() {
    loginEmailController
      ..text = ''
      ..clear();
    loginPasswordController
      ..text = ''
      ..clear();

    signUpEmailController
      ..text = ''
      ..clear();
    signUpPasswordController
      ..text = ''
      ..clear();
    signUpConfirmPasswordController
      ..text = ''
      ..clear();
    signUpNameController
      ..text = ''
      ..clear();

    signUpProfileImage.value = null;
  }

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
    // validation is done in UI, keep guard
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

      // Clear sensitive fields immediately after successful login.
      clearAuthFields();

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

      // Clear sensitive fields after signup
      clearAuthFields();

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

  Future<void> resetPassword(String email) async {
    isLoading.value = true;
    try {
      await resetPasswordUseCase(email.trim());
      Get.snackbar(
        'Success',
        'Password reset link sent',
        backgroundColor: AdminTheme.colors['primary'],
        colorText: AdminTheme.colors['surface'],
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to send password reset email: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
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

  void navigateToSignUp() {
    clearAuthFields();
    Get.toNamed('/signup');
  }

  void navigateToLogin() {
    clearAuthFields();
    Get.toNamed('/');
  }

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

      // Clear local controllers immediately on logout to avoid leaking cached creds
      clearAuthFields();

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
