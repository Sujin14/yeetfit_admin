import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../controllers/auth_controller.dart';
import 'auth_button.dart';
import 'auth_text_field.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Form(
      key: authController.signUpFormKey,
      child: Column(
        children: [
          AuthTextField(
            controller: authController.signUpNameController,
            labelText: 'Name',
            validator: FormValidators.validateUserName,
          ),
          AuthTextField(
            controller: authController.signUpEmailController,
            labelText: 'Email',
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          Obx(
            () => AuthTextField(
              controller: authController.signUpPasswordController,
              labelText: 'Password',
              obscureText: !authController.showSignUpPassword.value,
              validator: FormValidators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  authController.showSignUpPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AdminTheme.colors['textSecondary'],
                ),
                onPressed: authController.toggleSignUpPasswordVisibility,
              ),
            ),
          ),
          Obx(
            () => AuthTextField(
              controller: authController.signUpConfirmPasswordController,
              labelText: 'Confirm Password',
              obscureText: !authController.showSignUpConfirmPassword.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                return null;
              },
              suffixIcon: IconButton(
                icon: Icon(
                  authController.showSignUpConfirmPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AdminTheme.colors['textSecondary'],
                ),
                onPressed: authController.toggleSignUpConfirmPasswordVisibility,
              ),
            ),
          ),
          AuthButton(
            text: 'Sign Up',
            isLoading: authController.isLoading.value,
            onPressed: authController.signUp,
          ),
        ],
      ),
    );
  }
}
