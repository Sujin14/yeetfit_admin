// lib/features/settings/controllers/change_password_controller.dart
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/theme.dart';

class ChangePasswordController extends GetxController {
  final currentEmail = ''.obs;
  final currentPassword = ''.obs;
  final newPassword = ''.obs;
  final isLoading = false.obs;

  Future<void> changePassword() async {
    if (newPassword.value.trim().length < 6) {
      Get.snackbar('Error', 'New password must be at least 6 characters', backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return;
    }

    isLoading.value = true;
    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) throw 'No authenticated user';

      final cred = EmailAuthProvider.credential(email: currentEmail.value.trim(), password: currentPassword.value);
      await user.reauthenticateWithCredential(cred);

      await user.updatePassword(newPassword.value.trim());

      Get.snackbar('Success', 'Password updated', backgroundColor: AdminTheme.colors['success'], colorText: AdminTheme.colors['surface']);
      Get.back();
    } on FirebaseAuthException catch (e) {
      Get.snackbar('Error', e.message ?? 'Authentication failed', backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
    } catch (e) {
      Get.snackbar('Error', 'Could not update password: $e', backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
    } finally {
      isLoading.value = false;
    }
  }
}
