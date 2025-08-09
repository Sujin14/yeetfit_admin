import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/change_password_controller.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(ChangePasswordController());
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Change Password',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['onPrimary'],
          ),
        ),
        backgroundColor: AdminTheme.colors['primary'],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              onChanged: (v) => c.currentEmail.value = v,
              decoration: InputDecoration(
                labelText: 'Current Email',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AdminTheme.colors['inputBackground'],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => c.currentPassword.value = v,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Current Password',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AdminTheme.colors['inputBackground'],
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              onChanged: (v) => c.newPassword.value = v,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'New Password (min 6 chars)',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: AdminTheme.colors['inputBackground'],
              ),
            ),
            const SizedBox(height: 20),
            Obx(
              () => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(48),
                  backgroundColor: AdminTheme.colors['primary'],
                ),
                onPressed: c.isLoading.value ? null : c.changePassword,
                child: c.isLoading.value
                    ? const CircularProgressIndicator.adaptive()
                    : const Text('Change Password'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
