import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../widgets/diet_form_field.dart';
import '../widgets/workout_form_field.dart';
import '../../../../core/theme/theme.dart';

class PlanFormScreen extends GetView<PlanController> {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    print(
      'PlanFormScreen: Building with planType: ${controller.planType.value}',
    );
    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            controller.isEditMode.value
                ? 'Edit ${controller.planType.value.capitalizeFirstLetter} Plan'
                : 'Add ${controller.planType.value.capitalizeFirstLetter} Plan',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
        ),
        backgroundColor: AdminTheme.colors['surface'],
        elevation: 2,
      ),
      body: Obx(() {
        print(
          'PlanFormScreen: Rendering body with planType: ${controller.planType.value}',
        );
        return controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AdminTheme.colors['primary'],
                ),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: controller.planType.value == 'diet'
                    ? const DietFormFields()
                    : const WorkoutFormFields(),
              );
      }),
    );
  }
}
