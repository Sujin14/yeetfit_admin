import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/data/datasources/email_auth_service.dart';
import '../widgets/reauth_dialog.dart';

class EditProfileController extends GetxController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();
  final selectedImageFile = Rxn<File>();
  final photoUrl = RxnString();

  final _emailService = EmailAuthService();

  @override
  void onInit() {
    super.onInit();
    final user = FirebaseAuth.instance.currentUser;
    nameController.text = user?.displayName ?? '';
    emailController.text = user?.email ?? '';
    photoUrl.value = user?.photoURL;
  }

  Future<void> pickFromGallery() async {
    final x = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (x != null) {
      final file = File(x.path);
      if (file.lengthSync() > 5 * 1024 * 1024) {
        Get.snackbar(
          'Error',
          'Image size exceeds 5MB limit',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
        return;
      }
      selectedImageFile.value = file;
    }
  }

  Future<void> pickFromCamera() async {
    final x = await _picker.pickImage(
      source: ImageSource.camera,
      imageQuality: 80,
    );
    if (x != null) {
      final file = File(x.path);
      if (file.lengthSync() > 5 * 1024 * 1024) {
        Get.snackbar(
          'Error',
          'Image size exceeds 5MB limit',
          backgroundColor: AdminTheme.colors['error'],
          colorText: AdminTheme.colors['surface'],
        );
        return;
      }
      selectedImageFile.value = file;
    }
  }

  Future<bool> reauthenticateUser() async {
    final result = await Get.dialog<bool>(
      ReauthDialog(email: emailController.text.trim()),
    );
    return result ?? false;
  }

  Future<void> saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      Get.snackbar(
        'Error',
        'No authenticated user',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
      return;
    }

    isLoading.value = true;
    try {
      if (emailController.text.trim() != user.email) {
        final reauthenticated = await reauthenticateUser();
        if (!reauthenticated) {
          Get.snackbar(
            'Error',
            'Reauthentication required to update email',
            backgroundColor: AdminTheme.colors['error'],
            colorText: AdminTheme.colors['surface'],
          );
          isLoading.value = false;
          return;
        }
      }

      await _emailService.updateProfile(
        uid: user.uid,
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        profileImageFile: selectedImageFile.value,
      );

      await user.reload();
      final updated = FirebaseAuth.instance.currentUser;
      photoUrl.value = updated?.photoURL;
      Get.snackbar(
        'Success',
        'Profile updated',
        backgroundColor: AdminTheme.colors['success'],
        colorText: AdminTheme.colors['surface'],
      );
      Get.back();
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update profile: $e',
        backgroundColor: AdminTheme.colors['error'],
        colorText: AdminTheme.colors['surface'],
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
