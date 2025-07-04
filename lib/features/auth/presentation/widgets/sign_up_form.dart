import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final formKey = GlobalKey<FormState>();
    final emailController = TextEditingController();
    final passwordController = TextEditingController();
    final nameController = TextEditingController();

    return Obx(
      () => Form(
        key: formKey,
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              labelText: 'Name',
              validator: FormValidators.validateName,
            ),
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
              text: 'Sign Up',
              isLoading: authController.isLoading.value,
              onPressed: () async {
                if (formKey.currentState!.validate()) {
                  final success = await authController.signUp(
                    emailController.text.trim(),
                    passwordController.text.trim(),
                    nameController.text.trim(),
                  );
                  if (success) {
                    Get.offAllNamed('/home/dashboard');
                  }
                }
              },
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: () => Get.toNamed('/'),
              child: Text(
                'Already have an account? Login',
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
