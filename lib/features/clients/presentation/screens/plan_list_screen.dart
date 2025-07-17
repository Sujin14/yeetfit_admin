import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/plan_controller.dart';
import '../widgets/plan_list_item.dart';

// Displays a list of plans (diet or workout) for a specific user
class PlanListScreen extends StatelessWidget {
  final String type;
  final String uid;

  const PlanListScreen({super.key, required this.type, required this.uid});

  @override
  Widget build(BuildContext context) {
    final tag = 'plan-$uid-$type';
    final controller = Get.put(PlanController(), tag: tag);

    // Initializes controller with navigation arguments
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isInitialized) {
        controller.setupWithArguments({'uid': uid, 'type': type});
        controller.isInitialized = true;
      }
    });

    return Scaffold(
      // AppBar with dynamic title based on plan type
      appBar: AppBar(
        title: Text('${type.capitalizeFirst} Plans', style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary'])),
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
          // Shows message when no plans are available
          return Center(
            child: Text(
              'No ${type.capitalizeFirst} Plans Found',
              style: AdminTheme.textStyles['body']!.copyWith(color: AdminTheme.colors['textSecondary']),
            ),
          );
        }
        // Displays list of plans
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
      // Floating button to add a new plan
      floatingActionButton: FloatingActionButton(
        onPressed: () => controller.openPlanForm(mode: 'add'),
        backgroundColor: AdminTheme.colors['primary'],
        child: Icon(Icons.add, color: AdminTheme.colors['surface']),
      ),
    );
  }
}