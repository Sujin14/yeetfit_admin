// path: lib/features/auth/presentation/widgets/forgot_password_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/auth_controller.dart';

class ForgotPasswordButton extends StatelessWidget {
  const ForgotPasswordButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return TextButton(
      onPressed: () async {
        // Dismiss keyboard before dialog
        FocusScope.of(context).unfocus();
        final email = await _askForEmailDialog(context);
        if (email != null && email.trim().isNotEmpty) {
          // show loading at button level in controller
          await authController.resetPassword(email);
        }
      },
      child: Text(
        "Forgot Password?",
        style: AdminTheme.textStyles['body']!.copyWith(
          color: AdminTheme.colors['textSecondary'],
        ),
      ),
    );
  }

  Future<String?> _askForEmailDialog(BuildContext context) async {
    String email = '';
    return showDialog<String>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          "Reset Password",
          style: AdminTheme.textStyles['title'],
        ),
        content: TextField(
          decoration: InputDecoration(
            labelText: "Enter your email",
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8.r),
            ),
            filled: true,
            fillColor: AdminTheme.colors['surface']!.withOpacity(0.8),
          ),
          keyboardType: TextInputType.emailAddress,
          onChanged: (value) => email = value,
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
            child: Text(
              "Cancel",
              style: AdminTheme.textStyles['body'],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context, email);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.colors['primary'],
              foregroundColor: AdminTheme.colors['surface'],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
            child: Text(
              "Send",
              style: AdminTheme.textStyles['body'],
            ),
          ),
        ],
      ),
    );
  }
}
