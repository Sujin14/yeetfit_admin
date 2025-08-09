// lib/features/settings/controllers/contact_support_controller.dart
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../core/theme/theme.dart';

class ContactSupportController extends GetxController {
  final name = ''.obs;
  final email = ''.obs;
  final message = ''.obs;
  final isLoading = false.obs;
  final _firestore = FirebaseFirestore.instance;

  Future<void> send() async {
    if (name.value.trim().isEmpty || email.value.trim().isEmpty || message.value.trim().isEmpty) {
      Get.snackbar('Error', 'Please fill all fields', backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
      return;
    }
    isLoading.value = true;
    try {
      await _firestore.collection('support_messages').add({
        'name': name.value.trim(),
        'email': email.value.trim(),
        'message': message.value.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });
      Get.snackbar('Success', 'Message sent', backgroundColor: AdminTheme.colors['success'], colorText: AdminTheme.colors['surface']);
      Get.back();
    } catch (e) {
      Get.snackbar('Error', 'Failed to send message: $e', backgroundColor: AdminTheme.colors['error'], colorText: AdminTheme.colors['surface']);
    } finally {
      isLoading.value = false;
    }
  }
}
