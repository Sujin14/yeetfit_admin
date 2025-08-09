import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/data/datasources/email_auth_service.dart';

class ReauthDialog extends StatelessWidget {
  final String email;

  const ReauthDialog({super.key, required this.email});

  @override
  Widget build(BuildContext context) {
    final passwordController = TextEditingController();
    final isLoading = false.obs;
    final showPassword = false.obs;

    return AlertDialog(
      title: Text(
        'Reauthenticate',
        style: AdminTheme.textStyles['title']!.copyWith(
          color: AdminTheme.colors['textPrimary'],
        ),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Please enter your password to verify your identity.',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
          SizedBox(height: 16.h),
          Obx(() => TextField(
                controller: passwordController,
                obscureText: !showPassword.value,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      showPassword.value ? Icons.visibility : Icons.visibility_off,
                      color: AdminTheme.colors['textSecondary'],
                    ),
                    onPressed: () => showPassword.value = !showPassword.value,
                  ),
                ),
              )),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: false),
          child: Text(
            'Cancel',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
        ),
        Obx(() => ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AdminTheme.colors['primary'],
              ),
              onPressed: isLoading.value
                  ? null
                  : () async {
                      isLoading.value = true;
                      try {
                        await EmailAuthService().reauthenticate(
                          email,
                          passwordController.text.trim(),
                        );
                        Get.back(result: true);
                      } catch (e) {
                        Get.snackbar(
                          'Error',
                          'Reauthentication failed: $e',
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['surface'],
                        );
                        Get.back(result: false);
                      } finally {
                        isLoading.value = false;
                      }
                    },
              child: isLoading.value
                  ? SizedBox(
                      width: 24.w,
                      height: 24.h,
                      child: CircularProgressIndicator(
                        color: AdminTheme.colors['surface'],
                      ),
                    )
                  : Text(
                      'Verify',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['surface'],
                      ),
                    ),
            )),
      ],
    );
  }
}