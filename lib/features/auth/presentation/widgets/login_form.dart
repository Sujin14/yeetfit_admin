import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();

    return Obx(
      () => Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: emailController,
              labelText: 'Email',
              keyboardType: TextInputType.emailAddress,
              validator: FormValidators.validateEmail,
            ),
            CustomTextField(
              controller: passwordController,
              labelText: 'Password',
              obscureText: true,
              validator: FormValidators.validatePassword,
            ),
            SizedBox(height: 24.h),
            CustomButton(
              text: 'Login',
              isLoading: authController.isLoading.value,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final success = await authController.login(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                  );
                  if (success) {
                    Get.offAllNamed('/home/dashboard');
                  }
                }
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.toNamed('/signup'),
              child: Text(
                'Create Admin Account',
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['primary'],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
