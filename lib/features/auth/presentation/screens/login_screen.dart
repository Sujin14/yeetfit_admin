import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_widget.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

// Displays the login screen with a gradient background and form
class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // Applies gradient background for visual appeal
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              AdminTheme.colors['gradientStart']!,
              AdminTheme.colors['gradientMid']!,
              AdminTheme.colors['gradientEnd']!,
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 10.h),
                  // Displays app logo
                  Image.asset('assets/images/yeet_icon.png', height: 100.h),
                  SizedBox(height: 40.h),
                  Card(
                    elevation: 12,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    color: AdminTheme.colors['surface']!.withOpacity(0.95),
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: const [
                          LoginHeader(),
                          SizedBox(height: 20),
                          LoginForm(),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 20.h),
                  // Navigates to sign-up screen with gradient text for styling
                  TextButton(
                    onPressed: () => Get.toNamed('/signup'),
                    child: RichText(
                      text: TextSpan(
                        style: AdminTheme.textStyles['body'],
                        children: [
                          const TextSpan(text: "Don't have an account? "),
                          WidgetSpan(
                            alignment: PlaceholderAlignment.baseline,
                            baseline: TextBaseline.alphabetic,
                            child: GradientText(
                              text: 'Sign Up',
                              style: AdminTheme.textStyles['title']!,
                              gradient: LinearGradient(
                                colors: [
                                  AdminTheme.colors['signupGradientStart']!,
                                  AdminTheme.colors['signupGradientEnd']!,
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}