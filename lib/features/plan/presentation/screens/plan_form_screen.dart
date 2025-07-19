import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/plan/presentation/controllers/base_plan_controller.dart.dart';
import '../controllers/diet_plan_controller.dart.dart';
import '../controllers/workout_plan_controller.dart';
import '../../../../core/theme/theme.dart';
import '../widgets/diet_form_field.dart';
import '../widgets/workout_form_field.dart';

class PlanFormScreen extends StatelessWidget {
  const PlanFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final tag = 'plan-${args['uid']}-${args['type']}';
    final controller = args['type'] == 'diet'
        ? Get.find<DietPlanController>(tag: tag)
        : Get.find<WorkoutPlanController>(tag: tag);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          controller.isEditMode.value ? 'Edit ${controller.planType.capitalizeFirstLetter} Plan' : 'Add ${controller.planType.capitalizeFirstLetter} Plan',
          style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
        ),
        backgroundColor: AdminTheme.colors['surface'],
        elevation: 2,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AdminTheme.colors['textPrimary']),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator(color: AdminTheme.colors['primary']));
        }
        return SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Plan Details',
                style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
              ),
              SizedBox(height: 8.h),
              TextField(
                controller: controller.titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                ),
              ),
              SizedBox(height: 16.h),
              TextField(
                controller: controller.descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
                  focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: AdminTheme.colors['primary']!)),
                ),
                maxLines: 3,
              ),
              SizedBox(height: 16.h),
              if (controller is DietPlanController)
                DietFormFields(controllerTag: tag)
              else if (controller is WorkoutPlanController)
                WorkoutFormFields(controllerTag: tag),
              SizedBox(height: 32.h),
              Align(
                alignment: Alignment.bottomRight,
                child: ElevatedButton(
                  onPressed: () => controller.savePlan(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AdminTheme.colors['primary'],
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
                  ),
                  child: Text(
                    controller.isEditMode.value ? 'Update Plan' : 'Save Plan',
                    style: AdminTheme.textStyles['button']!.copyWith(color: AdminTheme.colors['surface']),
                  ),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}