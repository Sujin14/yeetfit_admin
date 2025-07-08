import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/plan_controller.dart';
import '../widgets/diet_form_field.dart';
import '../widgets/workout_form_field.dart';

class PlanManagementScreen extends StatelessWidget {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final args = Get.arguments;
    final tag = 'plan-${args['uid']}-${args['type']}';
    final PlanController controller = Get.find<PlanController>(tag: tag);

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            '${controller.planType.value.capitalizeFirstLetter} Plans',
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
            : controller.error.value.isNotEmpty
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
                      '${controller.isEditMode.value ? 'Edit' : 'Add New'} ${controller.planType.value.capitalizeFirstLetter} Plan',
                      style: AdminTheme.textStyles['title']!.copyWith(
                        color: AdminTheme.colors['textPrimary'],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    controller.planType.value == 'diet'
                        ? DietFormFields(controllerTag: tag)
                        : WorkoutFormFields(controllerTag: tag),
                  ],
                ),
              ),
      ),
    );
  }
}
