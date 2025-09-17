// path: lib/features/auth/presentation/widgets/sign_up_form.dart
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/auth_controller.dart';
import 'auth_button.dart';
import 'auth_text_field.dart';
import 'sign_up_profile.dart';

class SignUpForm extends StatelessWidget {
  const SignUpForm({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Form(
      key: authController.signUpFormKey,
      child: Column(
        children: [
          const SignUpProfileAvatar(isSignup: true),
          SizedBox(height: 16.h),
          AuthTextField(
            controller: authController.signUpNameController,
            labelText: 'Name*',
            validator: FormValidators.validateUserName,
          ),
          AuthTextField(
            controller: authController.signUpEmailController,
            labelText: 'Email*',
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          Obx(
            () => AuthTextField(
              controller: authController.signUpPasswordController,
              labelText: 'Password*',
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
              labelText: 'Confirm Password*',
              obscureText: !authController.showSignUpConfirmPassword.value,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please confirm your password';
                }
                if (value != authController.signUpPasswordController.text) {
                  return 'Passwords do not match';
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

          Obx(
            () => AuthButton(
              text: 'Sign Up',
              isLoading: authController.isLoading.value,
              onPressed: authController.isLoading.value
                  ? null
                  : () {
                      FocusScope.of(context).unfocus();

                      if (!authController.signUpFormKey.currentState!.validate()) {
                        return;
                      }
                      if (authController.signUpPasswordController.text !=
                          authController.signUpConfirmPasswordController.text) {
                        Get.snackbar(
                          'Error',
                          'Passwords do not match',
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['surface'],
                        );
                        return;
                      }
                      if (authController.signUpPasswordController.text.trim().length < 6) {
                        Get.snackbar(
                          'Error',
                          'Password must be at least 6 characters',
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['surface'],
                        );
                        return;
                      }

                      authController.signUp();
                    },
              loadingWidget: ShimmerLoading(height: 24.h, width: 24.w),
            ),
          ),
        ],
      ),
    );
  }
}
