import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/plan/presentation/controllers/base_plan_controller.dart.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/diet_plan_controller.dart.dart';
import '../controllers/workout_plan_controller.dart';
import '../widgets/plan_list_item.dart';

class PlanListScreen extends StatelessWidget {
  final String type;
  final String uid;

  const PlanListScreen({super.key, required this.type, required this.uid});

  @override
  Widget build(BuildContext context) {
    final tag = 'plan-$uid-$type';
    final controller = type == 'diet'
        ? Get.put<DietPlanController>(DietPlanController(), tag: tag)
        : Get.put<WorkoutPlanController>(WorkoutPlanController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isInitialized) {
        controller.setupWithArguments({'uid': uid, 'type': type});
        controller.isInitialized = true;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text('${type.capitalizeFirstLetter} Plans', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary'])),
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
        } else if (controller.plans.isEmpty) {
          return Center(
            child: Text(
              'No ${type.capitalizeFirstLetter} Plans Found',
              style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textSecondary']),
            ),
          );
        }
        return ListView.builder(
          itemCount: controller.plans.length,
          itemBuilder: (context, index) {
            final plan = controller.plans[index];
            return PlanListItem(
              plan: plan,
              onEdit: () => controller.openPlanForm(mode: 'edit', plan: plan),
              onDelete: () => controller.removePlan(plan.id!),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openPlanForm(mode: 'add'),
        backgroundColor: AdminTheme.colors['primary'],
        child: Icon(Icons.add, color: AdminTheme.colors['surface']),
      ),
    );
  }
}