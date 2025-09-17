// path: lib/features/settings/presentation/widgets/profile_avatar.dart
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';

class SignUpProfileAvatar extends StatelessWidget {
  final bool isSignup;
  const SignUpProfileAvatar({super.key, this.isSignup = false});

  @override
  Widget build(BuildContext context) {
    // expect AuthController to exist in Get's dependency graph
    final authController = Get.find<AuthController>();

    // smaller avatar: sensible default ~64
    const double avatarSize = 72.0;

    return GestureDetector(
      onTap: () {
        // Use controller's picker
        authController.pickProfileImage();
      },
      child: Obx(
        () {
          final file = authController.signUpProfileImage.value;
          return Stack(
            clipBehavior: Clip.none,
            children: [
              CircleAvatar(
                radius: avatarSize / 2,
                backgroundColor: AdminTheme.colors['surface'],
                backgroundImage: file != null ? FileImage(file) as ImageProvider : null,
                child: file == null
                    ? Icon(
                        Icons.person,
                        size: avatarSize / 2,
                        color: AdminTheme.colors['textSecondary'],
                      )
                    : null,
              ),
              // small plus icon overlapping bottom-right
              Positioned(
                bottom: -4,
                right: -4,
                child: Container(
                  height: 28.h,
                  width: 28.w,
                  decoration: BoxDecoration(
                    color: AdminTheme.colors['primary'],
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.add,
                    size: 18.sp,
                    color: AdminTheme.colors['surface'],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
