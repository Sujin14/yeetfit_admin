import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../data/datasources/email_auth_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/usecases/login_with_email.dart';
import '../../domain/usecases/sign_up_with_email.dart';

class AuthController extends GetxController {
  final LoginWithEmail loginWithEmail;
  final SignUpWithEmail signUpWithEmail;
  final isLoading = false.obs;

  AuthController()
    : loginWithEmail = LoginWithEmail(
        AuthRepositoryImpl(emailService: EmailAuthService()),
      ),
      signUpWithEmail = SignUpWithEmail(
        AuthRepositoryImpl(emailService: EmailAuthService()),
      );

  Future<bool> login(String email, String password) async {
    final emailError = FormValidators.validateEmail(email);
    final passwordError = FormValidators.validatePassword(password);
    if (emailError != null || passwordError != null) {
      Get.snackbar(
        'Error',
        emailError ?? passwordError!,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }
    isLoading.value = true;
    final success = await loginWithEmail(email, password);
    isLoading.value = false;
    if (!success) {
      Get.snackbar(
        'Error',
        'Not an admin account',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    }
    return success;
  }

  Future<bool> signUp(String email, String password, String name) async {
    final emailError = FormValidators.validateEmail(email);
    final passwordError = FormValidators.validatePassword(password);
    final nameError = FormValidators.validateName(name);
    if (emailError != null || passwordError != null || nameError != null) {
      Get.snackbar(
        'Error',
        emailError ?? passwordError ?? nameError!,
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return false;
    }
    isLoading.value = true;
    final success = await signUpWithEmail(email, password, name);
    isLoading.value = false;
    if (!success) {
      Get.snackbar(
        'Error',
        'Signup failed',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    }
    return success;
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
