import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/plan_model.dart';
import '../controllers/plan_controller.dart';

class PlanManagementScreen extends StatelessWidget {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use the same tag as in ClientPlanActions to reuse the controller
    final PlanController controller = Get.find<PlanController>(
      tag: 'plan-${Get.arguments['uid']}',
    );

    return Scaffold(
      appBar: AppBar(
        title: Obx(
          () => Text(
            '${controller.planType.value.capitalizeFirstLetter} Plans',
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
          'PlanManagementScreen: Rendering with ${controller.plans.length} plans',
        );
        return controller.isLoading.value
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
                itemCount: controller.plans.length,
                itemBuilder: (context, index) {
                  final plan = controller.plans[index];
                  return PlanListItem(
                    plan: plan,
                    onEdit: () {
                      print(
                        'PlanManagementScreen: Navigating to edit plan with ID: ${plan.id}, title: ${plan.title}',
                      );
                      controller
                          .initializeForm(); // Ensure form is initialized with plan data
                      Get.toNamed(
                        '/home/plan-form',
                        arguments: {
                          'uid': controller.userId.value,
                          'type': controller.planType.value,
                          'mode': 'edit',
                          'planId': plan.id,
                          'plan': plan,
                        },
                      );
                    },
                    onDelete: () => controller.deletePlan(plan.id!),
                  );
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print(
            'PlanManagementScreen: Navigating to /home/plan-form with type: ${controller.planType.value}, uid: ${controller.userId.value}',
          );
          controller.initializeForm();
          Get.toNamed(
            '/home/plan-form',
            arguments: {
              'uid': controller.userId.value,
              'type': controller.planType.value,
              'mode': 'add',
            },
          );
        },
        backgroundColor: AdminTheme.colors['primary'],
        child: const Icon(Icons.add),
      ),
    );
  }
}

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlanListItem({
    super.key,
    required this.plan,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              plan.title,
              style: AdminTheme.textStyles['title']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
              ),
            ),
            SizedBox(height: 8.h),
            if (plan.type == 'diet') ...[
              ...(plan.details['meals'] as List?)?.map((meal) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          meal['name']?.toString() ?? 'Unnamed Meal',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textSecondary'],
                          ),
                        ),
                        ...(meal['foods'] as List?)?.map(
                              (food) => Text(
                                '${food['quantity']?.toString() ?? ''} - ${food['calories']?.toString() ?? '0'} kcal',
                                style: AdminTheme.textStyles['body']!.copyWith(
                                  color: AdminTheme.colors['textSecondary'],
                                ),
                              ),
                            ) ??
                            [],
                      ],
                    );
                  }) ??
                  [],
            ] else ...[
              ...(plan.details['exercises'] as List?)?.map((exercise) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          exercise['name']?.toString() ?? 'Unnamed Exercise',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textSecondary'],
                          ),
                        ),
                        Text(
                          'Reps: ${exercise['reps']?.toString() ?? ''}, Sets: ${exercise['sets']?.toString() ?? ''}',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textSecondary'],
                          ),
                        ),
                        if (exercise['videoUrl']?.toString().isNotEmpty ??
                            false)
                          Text(
                            'Video: ${exercise['videoUrl']?.toString() ?? ''}',
                            style: AdminTheme.textStyles['body']!.copyWith(
                              color: AdminTheme.colors['textSecondary'],
                            ),
                          ),
                      ],
                    );
                  }) ??
                  [],
            ],
            SizedBox(height: 8.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: onEdit,
                  child: Text(
                    'Edit',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['primary'],
                    ),
                  ),
                ),
                TextButton(
                  onPressed: onDelete,
                  child: Text(
                    'Delete',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['error'],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
