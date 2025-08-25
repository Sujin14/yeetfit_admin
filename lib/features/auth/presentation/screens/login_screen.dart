import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/auth_controller.dart';
import '../widgets/auth_nav_link.dart';
import '../widgets/login_form.dart';
import '../widgets/login_header.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = Get.find<AuthController>();
    final width = MediaQuery.of(context).size.width;

    // Defining breakpoints
    final bool isTablet = width >= 600 && width < 1024;
    final bool isDesktop = width >= 1024;

    // Decide max content width
    double maxWidth = double.infinity;
    if (isTablet) {
      maxWidth = 600; // tablet width cap
    } else if (isDesktop) {
      maxWidth = 600; // desktop width cap
    }

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
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
            child: Obx(
              () => authController.isLoading.value
                  ? Center(child: ShimmerLoading(height: 200.h))
                  : ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: maxWidth),
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 16.h,
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(height: 10.h),
                            Image.asset(
                              'assets/images/yeet_icon.png',
                              height: 100.h,
                            ),
                            SizedBox(height: 40.h),
                            Card(
                              elevation: 12,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              color: AdminTheme.colors['surface']!.withOpacity(
                                0.95,
                              ),
                              child: Padding(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 32.h,
                                ),
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
                            AuthNavLink(
                              prefixText: "Don't have an account? ",
                              linkText: 'Sign Up',
                              onPressed: authController.navigateToSignUp,
                              gradientColors: [
                                AdminTheme.colors['signupGradientStart']!,
                                AdminTheme.colors['signupGradientEnd']!,
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
