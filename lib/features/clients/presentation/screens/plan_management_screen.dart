import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/plan_model.dart';
import '../controllers/plan_controller.dart';

class PlanManagementScreen extends StatelessWidget {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final PlanController controller = Get.find<PlanController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('${controller.planType.value.capitalizeFirstLetter} Plans'),
        backgroundColor: AdminTheme.colors['primary'],
      ),
      body: Obx(() {
        print(
          'PlanManagementScreen: Rendering with ${controller.plans.length} plans',
        );
        return controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.plans.isEmpty
            ? Center(child: Text('No ${controller.planType.value} plans found'))
            : ListView.builder(
                itemCount: controller.plans.length,
                itemBuilder: (context, index) {
                  final plan = controller.plans[index];
                  return PlanListItem(plan: plan);
                },
              );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
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

  const PlanListItem({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final PlanController controller = Get.find<PlanController>();

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ListTile(
        title: Text(plan.title, style: TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(
          plan.type == 'diet'
              ? '${plan.details['meals']?.length ?? 0} meals'
              : '${plan.details['exercises']?.length ?? 0} exercises',
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AdminTheme.colors['primary']),
              onPressed: () {
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
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
              onPressed: () => controller.deletePlan(plan.id!),
            ),
          ],
        ),
      ),
    );
  }
}
