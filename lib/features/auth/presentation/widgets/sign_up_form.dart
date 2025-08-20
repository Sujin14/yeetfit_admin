import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../../../settings/presentation/widgets/profile_avatar.dart';
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
          const ProfileAvatar(isSignup: true),
          SizedBox(height: 16.h),
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
          Obx(
            () => AuthButton(
              text: 'Sign Up',
              isLoading: authController.isLoading.value,
              onPressed: authController.isLoading.value
                  ? () {}
                  : () => authController.signUp(),
              loadingWidget: ShimmerLoading(height: 24.h, width: 24.w),
            ),
          ),
        ],
      ),
    );
  }
}