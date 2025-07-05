import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/plan_controller.dart';
import '../widgets/plan_list_item.dart';
import '../../../../core/theme/theme.dart';

class PlanManagementScreen extends GetView<PlanController> {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          '${controller.planType.value.capitalize} Plans',
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
            : controller.plans.isEmpty
            ? Center(
                child: Text(
                  'No ${controller.planType.value} plans found',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.all(16.w),
                itemCount: controller.plans.length,
                itemBuilder: (context, index) {
                  final plan = controller.plans[index];
                  return PlanListItem(
                    plan: plan,
                    onEdit: () => Get.toNamed(
                      '/home/plan-form',
                      arguments: {
                        'uid': controller.userId.value,
                        'mode': 'edit',
                        'type': controller.planType.value,
                        'planId': plan.id,
                      },
                    ),
                    onDelete: () async {
                      final success = await controller.deletePlan(plan.id!);
                      if (!success) {
                        Get.snackbar(
                          'Error',
                          controller.error.value,
                          backgroundColor: AdminTheme.colors['error'],
                          colorText: AdminTheme.colors['textPrimary'],
                        );
                      }
                    },
                  );
                },
              ),
      ),
    );
  }
}
