import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/sign_up_with_email.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final isLoading = false.obs;
  
  // Form keys
  final loginFormKey = GlobalKey<FormState>();
  final signUpFormKey = GlobalKey<FormState>();
  
  // Text controllers
  final loginEmailController = TextEditingController();
  final loginPasswordController = TextEditingController();
  final signUpEmailController = TextEditingController();
  final signUpPasswordController = TextEditingController();
  final signUpConfirmPasswordController = TextEditingController();
  final signUpNameController = TextEditingController();
  
  // Password visibility
  final showLoginPassword = false.obs;
  final showSignUpPassword = false.obs;
  final showSignUpConfirmPassword = false.obs;

  AuthController()
      : loginWithEmail = LoginWithEmail(
          AuthRepositoryImpl(emailService: EmailAuthService()),
        ),
        signUpWithEmail = SignUpWithEmail(
          AuthRepositoryImpl(emailService: EmailAuthService()),
        );

  @override
  void onClose() {
    // Dispose controllers
    loginEmailController.dispose();
    loginPasswordController.dispose();
    signUpEmailController.dispose();
    signUpPasswordController.dispose();
    signUpConfirmPasswordController.dispose();
    signUpNameController.dispose();
    super.onClose();
  }

  Future<bool> login() async {
    if (!loginFormKey.currentState!.validate()) {
      return false;
    }
    isLoading.value = true;
    final success = await loginWithEmail(
      loginEmailController.text.trim(),
      loginPasswordController.text.trim(),
    );
    isLoading.value = false;
    if (!success) {
      Get.snackbar(
        'Error',
        'Not an admin account',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } else {
      Get.offAllNamed('/home/dashboard');
    }
    return success;
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
    isLoading.value = true;
    final success = await signUpWithEmail(
      signUpEmailController.text.trim(),
      signUpPasswordController.text.trim(),
      signUpNameController.text.trim(),
    );
    isLoading.value = false;
    if (!success) {
      Get.snackbar(
        'Error',
        'Signup failed',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } else {
      Get.offAllNamed('/home/dashboard');
    }
    return success;
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
    Get.toNamed('/signup');
  }

  void navigateToLogin() {
    Get.toNamed('/');
  }

  Future<bool> isAdmin(String uid) async {
    return await EmailAuthService().isAdmin(uid);
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
}