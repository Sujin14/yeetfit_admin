import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_widget.dart';
import '../widgets/sign_up_form.dart';

// Displays the sign-up screen with a gradient background and form
class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Applies gradient background for visual consistency
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
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 40.h),
                  // Displays app logo
                  Image.asset('assets/images/yeet_icon.png', height: 100.h),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    color: AdminTheme.colors['surface'],
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                      child: const SignUpForm(),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Navigates to login screen with gradient text for styling
                  TextButton(
                    onPressed: () => Get.toNamed('/'),
                    child: RichText(
                      text: TextSpan(
                        style: AdminTheme.textStyles['body'],
                        children: [
                          const TextSpan(text: "Already have an account? "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GradientText(
                              text: 'Login',
                              style: AdminTheme.textStyles['title']!,
                              gradient: LinearGradient(
                                colors: [
                                  AdminTheme.colors['gradientStart']!,
                                  AdminTheme.colors['gradientMid']!,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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