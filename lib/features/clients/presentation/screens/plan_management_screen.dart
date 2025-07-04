import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../data/models/plan_model.dart';
import '../controllers/plan_controller.dart';
import '../widgets/plan_list_item.dart';

class PlanManagementScreen extends GetView<PlanController> {
  const PlanManagementScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = Get.arguments?['uid'] as String? ?? '';
    final type = Get.arguments?['type'] as String? ?? 'diet';

    return Scaffold(
      appBar: CustomAppBar(
        title: 'Manage ${type.capitalizeFirst} Plans',
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AdminTheme.colors['textPrimary'],
            size: 20.w,
          ),
          onPressed: () => Get.back(),
        ),
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.error.value.isNotEmpty
            ? Center(
                child: Text(
                  controller.error.value,
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
              )
            : FutureBuilder<List<PlanModel>>(
                future: controller.getClientPlans(uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error loading plans',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                    );
                  }
                  final plans =
                      snapshot.data
                          ?.where((plan) => plan.type == type)
                          .toList() ??
                      [];
                  if (plans.isEmpty) {
                    return Center(
                      child: Text(
                        'No $type plans available',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                    );
                  }
                  return ListView.builder(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 16.h,
                    ),
                    itemCount: plans.length,
                    itemBuilder: (context, index) {
                      return PlanListItem(
                        plan: plans[index],
                        type: type,
                        onEdit: () => Get.toNamed(
                          '/home/$type-plan-form',
                          arguments: {
                            'uid': uid,
                            'mode': 'edit',
                            'plan': plans[index],
                            'type': type,
                          },
                        ),
                        onDelete: () async {
                          final confirm = await _showDeleteConfirmation(
                            context,
                            type,
                          );
                          if (confirm) {
                            await controller.deletePlan(plans[index].id, type);
                            Get.forceAppUpdate();
                          }
                        },
                      );
                    },
                  );
                },
              ),
      ),
    );
  }

  Future<bool> _showDeleteConfirmation(
    BuildContext context,
    String type,
  ) async {
    return await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              'Delete ${type.capitalizeFirst} Plan',
              style: AdminTheme.textStyles['title']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
              ),
            ),
            content: Text(
              'Are you sure you want to delete this $type plan?',
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textSecondary'],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(
                  'Cancel',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(
                  'Delete',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['error'],
                  ),
                ),
              ),
            ],
          ),
        ) ??
        false;
  }
}

// Extension to capitalize first letter
extension StringExtension on String {
  String get capitalizeFirstLetter =>
      isNotEmpty ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';
}
