import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/edit_profile_controller.dart';
import '../widgets/edit_profile_form.dart';
import '../widgets/profile_avatar.dart';

class EditProfileScreen extends StatelessWidget {
  const EditProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.put(EditProfileController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Edit Profile',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['onPrimary'],
          ),
        ),
        backgroundColor: AdminTheme.colors['primary'],
      ),
      body: Obx(() => c.isLoading.value
          ? Center(child: ShimmerLoading(height: 200.h))
          : SingleChildScrollView(
              padding: EdgeInsets.symmetric(vertical: 20.h),
              child: Column(
                children: [
                  const ProfileAvatar(),
                  SizedBox(height: 20.h),
                  Card(
                    margin: EdgeInsets.symmetric(horizontal: 16.w),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16.w),
                      child: const EditProfileForm(),
                    ),
                  ),
                ],
              ),
            )),
    );
  }
}