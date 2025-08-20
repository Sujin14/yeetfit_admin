import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_nav_link.dart';
import '../widgets/sign_up_form.dart';
import '../widgets/sign_up_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final isWeb = MediaQuery.of(context).size.width > 1800; 

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
          child: Obx(() => authController.isLoading.value
              ? Center(child: ShimmerLoading(height: 200.h))
              : LayoutBuilder(
                  builder: (context, constraints) {
                    // Constrain content height to fit viewport in web view
                    final contentHeight = isWeb
                        ? constraints.maxHeight - 32.h // Adjust for SafeArea padding
                        : double.infinity;

                    return Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          maxHeight: contentHeight,
                          maxWidth: isWeb ? 600.0 : double.infinity, // Limit form width for web
                        ),
                        child: SingleChildScrollView(
                          physics: isWeb
                              ? const NeverScrollableScrollPhysics() // Disable scroll for web
                              : const BouncingScrollPhysics(),
                          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: isWeb ? 20.h : 40.h), // Reduced spacing for web
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxHeight: isWeb ? 80.0 : 100.h,
                                  maxWidth: isWeb ? 80.0 : 100.w,
                                ),
                                child: Image.asset(
                                  'assets/images/yeet_icon.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                              SizedBox(height: 16.h), // Reduced spacing
                              ConstrainedBox(
                                constraints: BoxConstraints(
                                  maxWidth: isWeb ? 400.0 : double.infinity,
                                ),
                                child: Card(
                                  elevation: 10,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16.r),
                                  ),
                                  color: AdminTheme.colors['surface'],
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 16.w,
                                      vertical: isWeb ? 24.h : 32.h, // Reduced padding for web
                                    ),
                                    child: Column(
                                      children: const [
                                        SignUpHeader(),
                                        SizedBox(height: 16), // Reduced spacing
                                        SignUpForm(),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              SizedBox(height: 16.h), // Reduced spacing
                              AuthNavLink(
                                prefixText: "Already have an account? ",
                                linkText: 'Login',
                                onPressed: authController.navigateToLogin,
                                gradientColors: [
                                  AdminTheme.colors['gradientStart']!,
                                  AdminTheme.colors['gradientMid']!,
                                ],
                              ),
                              if (!isWeb) SizedBox(height: 20.h), // Extra spacing for mobile
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                )),
        ),
      ),
    );
  }
}