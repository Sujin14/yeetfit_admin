import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/form_validators.dart';
import '../../../../core/widgets/shimmer_loading.dart';
import '../controllers/edit_profile_controller.dart';

class EditProfileForm extends StatelessWidget {
  const EditProfileForm({super.key});

  @override
  Widget build(BuildContext context) {
    final c = Get.find<EditProfileController>();

    return Form(
      key: GlobalKey<FormState>(),
      child: Column(
        children: [
          TextFormField(
            controller: c.nameController,
            decoration: InputDecoration(
              labelText: 'Name',
              filled: true,
              fillColor: AdminTheme.colors['inputBackground'],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            validator: FormValidators.validateUserName,
          ),
          SizedBox(height: 12.h),
          TextFormField(
            controller: c.emailController,
            decoration: InputDecoration(
              labelText: 'Email',
              filled: true,
              fillColor: AdminTheme.colors['inputBackground'],
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
            ),
            keyboardType: TextInputType.emailAddress,
            validator: FormValidators.validateEmail,
          ),
          SizedBox(height: 20.h),
          Obx(() => ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.colors['primary'],
                  minimumSize: Size(double.infinity, 48.h),
                ),
                onPressed: c.isLoading.value
                    ? null
                    : () {
                        if (c.nameController.text.trim().isEmpty || c.emailController.text.trim().isEmpty) {
                          Get.snackbar(
                            'Error',
                            'Please fill all required fields',
                            backgroundColor: AdminTheme.colors['error'],
                            colorText: AdminTheme.colors['surface'],
                          );
                          return;
                        }
                        c.saveProfile();
                      },
                child: c.isLoading.value
                    ? ShimmerLoading(height: 24.h, width: 24.w)
                    : Text(
                        'Save Changes',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['surface'],
                        ),
                      ),
              )),
        ],
      ),
    );
  }
}