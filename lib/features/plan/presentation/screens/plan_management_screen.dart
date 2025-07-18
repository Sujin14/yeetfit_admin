import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/plan/presentation/controllers/base_plan_controller.dart.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/diet_plan_controller.dart.dart';
import '../controllers/workout_plan_controller.dart';
import '../widgets/diet_form_field.dart';
import '../widgets/workout_form_field.dart';


class PlanManagementScreen extends StatelessWidget {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final tag = 'plan-${args['uid']}-${args['type']}';
    final controller = args['type'] == 'diet'
        ? Get.find<DietPlanController>(tag: tag)
        : Get.find<WorkoutPlanController>(tag: tag);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            '${controller.planType.capitalizeFirstLetter} Plans',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: AdminTheme.colors['textPrimary'],
            ),
            onPressed: () => Get.back(),
          ),
        ),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AdminTheme.colors['primary'],
                ),
              )
            : controller.error.value.isNotEmpty && !controller.error.value.contains('fill all required fields')
            ? CustomErrorWidget(
                message: controller.error.value,
                onRetry: () => controller.fetchPlans(),
              )
            : SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${controller.isEditMode.value ? 'Edit' : 'Add New'} ${controller.planType.capitalizeFirstLetter} Plan',
                      style: AdminTheme.textStyles['title']!.copyWith(
                        color: AdminTheme.colors['textPrimary'],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    controller is DietPlanController
                        ? DietFormFields(controllerTag: tag)
                        : WorkoutFormFields(controllerTag: tag),
                  ],
                ),
              ),
      ),
    );
  }
}