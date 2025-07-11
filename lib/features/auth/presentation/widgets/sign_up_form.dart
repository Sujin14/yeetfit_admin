import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../controllers/auth_controller.dart';

class SignUpForm extends StatefulWidget {
  const SignUpForm({super.key});

  @override
  State<SignUpForm> createState() => _SignUpFormState();
}

class _SignUpFormState extends State<SignUpForm> {
  final formKey = GlobalKey<FormState>();
  final authController = Get.find<AuthController>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();

  bool showPassword = false;
  bool showConfirmPassword = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              obscureText: !showPassword,
              validator: FormValidators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  showPassword ? Icons.visibility : Icons.visibility_off,
                  color: AdminTheme.colors['textSecondary'],
                ),
                onPressed: () => setState(() => showPassword = !showPassword),
              ),
            ),
            CustomTextField(
              controller: confirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: !showConfirmPassword,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != passwordController.text) {
                  return 'Passwords do not match';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                  color: AdminTheme.colors['textSecondary'],
                ),
                onPressed: () =>
                    setState(() => showConfirmPassword = !showConfirmPassword),
              ),
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
                    confirmPasswordController.text.trim(),
                    nameController.text.trim(),
                  );
                  if (success) {
                    Get.offAllNamed('/home/dashboard');
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
