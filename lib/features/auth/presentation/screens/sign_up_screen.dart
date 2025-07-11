import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/gradient_widget.dart';
import '../widgets/sign_up_form.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFF892C), Color(0xFFFE9A0B), Color(0xFFF8DC65)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 24.w),
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
                        horizontal: 20.w,
                        vertical: 32.h,
                      ),
                      child: const SignUpForm(),
                    ),
                  ),
                  SizedBox(height: 20.h),
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
                              gradient: const LinearGradient(
                                colors: [
                                  Color.fromARGB(255, 166, 4, 191),
                                  Color.fromARGB(255, 46, 128, 229),
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
