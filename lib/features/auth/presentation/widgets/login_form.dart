import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../controllers/auth_controller.dart';
import 'auth_button.dart';
import 'auth_text_field.dart';
import 'forgot_password_button.dart';

class LoginForm extends StatelessWidget {
  const LoginForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Form(
      key: authController.loginFormKey,
      child: Column(
        children: [
          AuthTextField(
            controller: authController.loginEmailController,
            labelText: 'Email*',
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          Obx(
            () => AuthTextField(
              controller: authController.loginPasswordController,
              labelText: 'Password*',
              obscureText: !authController.showLoginPassword.value,
              validator: FormValidators.validatePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  authController.showLoginPassword.value
                      ? Icons.visibility
                      : Icons.visibility_off,
                  color: AdminTheme.colors['textSecondary'],
                ),
                onPressed: authController.toggleLoginPasswordVisibility,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: ForgotPasswordButton(),
          ),

          Obx(
            () => AuthButton(
              text: 'Login',
              isLoading: authController.isLoading.value,
              onPressed: authController.isLoading.value
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();
                      if (!authController.loginFormKey.currentState!.validate()) {
                        return;
                      }
                      authController.login();
                    },
            ),
          ),
        ],
      ),
    );
  }
}
