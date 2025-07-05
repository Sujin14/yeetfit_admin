import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:yeetfit_admin/features/clients/presentation/widgets/plan_form_fields.dart';
import '../controllers/plan_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_button.dart';
import '../widgets/diet_form_field.dart';
import '../widgets/workout_form_field.dart';

// Extension to capitalize the first letter of a string
extension StringExtension on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }
}

class PlanFormScreen extends GetView<PlanController> {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditMode.value
              ? 'Edit ${controller.planType.value.capitalizeFirstLetter} Plan'
              : 'Add ${controller.planType.value.capitalizeFirstLetter} Plan',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
          ),
        ),
        backgroundColor: AdminTheme.colors['surface'],
        elevation: 2,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AdminTheme.colors['primary'],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: controller.formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (controller.planType.value == 'diet') ...[
                        const DietFormFields(),
                      ] else ...[
                        const WorkoutFormFields(),
                      ],
                      SizedBox(height: 16.h),
                      CustomButton(
                        text: controller.isEditMode.value
                            ? 'Update Plan'
                            : 'Save Plan',
                        isLoading: controller.isLoading.value,
                        onPressed: () async {
                          if (controller.formKey.currentState!.validate()) {
                            final success = await controller.savePlan();
                            if (!success) {
                              Get.snackbar(
                                'Error',
                                controller.error.value,
                                backgroundColor: AdminTheme.colors['error'],
                                colorText: AdminTheme.colors['textPrimary'],
                              );
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
