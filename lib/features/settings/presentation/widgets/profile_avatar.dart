import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../core/theme/theme.dart';
import '../../../auth/presentation/controllers/auth_controller.dart';
import '../controllers/edit_profile_controller.dart';

class ProfileAvatar extends StatelessWidget {
  final bool isSignup;

  const ProfileAvatar({super.key, this.isSignup = false});

  @override
  Widget build(BuildContext context) {
    final controller = isSignup ? Get.find<AuthController>() : Get.find<EditProfileController>();
    final imageFile = isSignup ? (controller as AuthController).signUpProfileImage : (controller as EditProfileController).selectedImageFile;
    final photoUrl = isSignup ? RxnString() : (controller as EditProfileController).photoUrl;

    return Obx(() {
      final file = imageFile.value;
      final url = photoUrl.value;
      Widget image;
      if (file != null) {
        image = ClipRRect(
          borderRadius: BorderRadius.circular(70.r),
          child: Image.file(file, width: 140.w, height: 140.h, fit: BoxFit.cover),
        );
      } else if (url != null && url.isNotEmpty) {
        image = ClipRRect(
          borderRadius: BorderRadius.circular(70.r),
          child: CachedNetworkImage(
            imageUrl: url,
            width: 140.w,
            height: 140.h,
            fit: BoxFit.cover,
            placeholder: (context, url) => CircularProgressIndicator(
              color: AdminTheme.colors['primary'],
            ),
            errorWidget: (context, url, error) => Icon(
              Icons.error,
              color: AdminTheme.colors['error'],
              size: 64.w,
            ),
          ),
        );
      } else {
        image = CircleAvatar(
          radius: 70.r,
          backgroundColor: AdminTheme.colors['surface'],
          child: Icon(
            Icons.person,
            size: 64.w,
            color: AdminTheme.colors['primary'],
          ),
        );
      }
      return Column(
        children: [
          Container(
            width: 140.w,
            height: 140.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(70.r),
              boxShadow: [
                BoxShadow(color: Colors.black.withOpacity(0.12), blurRadius: 8.r),
              ],
            ),
            child: image,
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton.icon(
                onPressed: isSignup ? (controller as AuthController).pickProfileImage : (controller as EditProfileController).pickFromGallery,
                icon: Icon(Icons.photo_library, size: 20.w),
                label: Text(
                  'Gallery',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['surface'],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.colors['primary'],
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
              ),
              SizedBox(width: 8.w),
              OutlinedButton.icon(
                onPressed: isSignup
                    ? () async {
                        final picker = ImagePicker();
                        final picked = await picker.pickImage(
                          source: ImageSource.camera,
                          imageQuality: 80,
                        );
                        if (picked != null) {
                          final file = File(picked.path);
                          if (file.lengthSync() > 5 * 1024 * 1024) {
                            Get.snackbar(
                              'Error',
                              'Image size exceeds 5MB limit',
                              backgroundColor: AdminTheme.colors['error'],
                              colorText: AdminTheme.colors['surface'],
                            );
                            return;
                          }
                          (controller as AuthController).signUpProfileImage.value = file;
                        }
                      }
                    : (controller as EditProfileController).pickFromCamera,
                icon: Icon(Icons.camera_alt, size: 20.w),
                label: Text(
                  'Camera',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['primary'],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                ),
              ),
            ],
          ),
        ],
      );
    });
  }
}