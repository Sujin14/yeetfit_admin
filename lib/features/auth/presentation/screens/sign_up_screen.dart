import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_nav_link.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/sign_up_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AdminTheme.colors['signupGradientStart']!,
              AdminTheme.colors['signupGradientMid']!,
              AdminTheme.colors['signupGradientEnd']!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  Image.asset('assets/images/yeet_icon.png', height: 100.h),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: AdminTheme.colors['surface'],
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 16.w,
                        vertical: 32.h,
                      ),
                      child: Column(
                        children: const [
                          SignUpHeader(),
                          SizedBox(height: 20),
                          SignUpForm(),
                        ],
                      ),
                    ),
                  ),
                  AuthNavLink(
                    prefixText: "Already have an account? ",
                    linkText: 'Login',
                    onPressed: authController.navigateToLogin,
                    gradientColors: [
                      AdminTheme.colors['gradientStart']!,
                      AdminTheme.colors['gradientMid']!,
                    ],
                  ),
                  SizedBox(height: 20.h),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
