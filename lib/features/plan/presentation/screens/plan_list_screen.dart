import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:yeetfit_admin/features/plan/presentation/controllers/base_plan_controller.dart.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/shimmer_loading.dart';
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
        ? Get.find<DietPlanController>(tag: tag)
        : Get.find<WorkoutPlanController>(tag: tag);

    return Obx(() {
      return Scaffold(
        appBar: AppBar(
          title: Text(
            '${type.capitalizeFirstLetter} Plans',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: AdminTheme.colors['textPrimary']),
            onPressed: () => Get.back(),
          ),
        ),
        body: controller.isLoading.value
            ? ListView.builder(
                itemCount: 3,
                itemBuilder: (_, __) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                  child: ShimmerLoading(height: 60.h),
                ),
              )
            : controller.plans.isEmpty
                ? Center(
                    child: Text(
                      'No ${type.capitalizeFirstLetter} Plans Found',
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
                        onEdit: () => controller.openPlanForm(mode: 'edit', plan: plan),
                        onDelete: () => controller.removePlan(plan.id!),
                        isFirst: index == 0,
                      );
                    },
                  ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => controller.openPlanForm(mode: 'add'),
          backgroundColor: AdminTheme.colors['primary'],
          child: Icon(Icons.add, color: AdminTheme.colors['surface']),
        ),
      );
    });
  }
}