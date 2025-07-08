import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/plan_controller.dart';

class PlanListScreen extends StatelessWidget {
  final String type;
  final String uid;

  const PlanListScreen({super.key, required this.type, required this.uid});

  @override
  Widget build(BuildContext context) {
    final tag = '$uid-$type';
    final controller = Get.put(PlanController(), tag: tag);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isInitialized) {
        controller.setupWithArguments({'uid': uid, 'type': type});
        controller.isInitialized = true;
      }
    });

    return Scaffold(
      appBar: AppBar(title: Text('${type.capitalizeFirst} Plans')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.plans.isEmpty) {
          return Center(child: Text('No ${type.capitalizeFirst} Plans Found'));
        }
        return ListView.builder(
          itemCount: controller.plans.length,
          itemBuilder: (context, index) {
            final plan = controller.plans[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ListTile(
                title: Text(plan.title),
                subtitle: Text(plan.details['description'] ?? ''),
                trailing: SizedBox(
                  width: 96,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () => controller.editPlan(plan),
                        tooltip: 'Edit',
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => controller.removePlan(uid),
                        tooltip: 'Delete',
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(
            type == 'diet'
                ? '/home/diet-plan-management'
                : '/home/workout-plan-management',
            arguments: {'uid': uid, 'type': type, 'mode': 'add'},
          );
        },
        backgroundColor: AdminTheme.colors['primary'],
        child: const Icon(Icons.add),
      ),
    );
  }
}
