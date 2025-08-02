import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/client_progress_controller.dart';

class ProgressCard extends StatelessWidget {
  final String title;
  final String dataKey;
  final String goalField;
  final String currentField;
  final String unit;

  const ProgressCard({
    super.key,
    required this.title,
    required this.dataKey,
    required this.goalField,
    required this.currentField,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientProgressController>();
    final isExpanded = false.obs;

    return Obx(() {
      final data = controller.progressData[dataKey];
      final double? goal = data != null ? (data[goalField] as num?)?.toDouble() : null;
      final double? current = data != null ? (data[currentField] as num?)?.toDouble() : null;
      final percentage = goal != null && current != null && goal > 0
          ? ((current / goal) * 100).clamp(0, 100).toStringAsFixed(1)
          : '0.0';

      return Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
        child: ExpansionTile(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '$percentage% achieved',
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['primary'],
                ),
              ),
            ],
          ),
          onExpansionChanged: (expanded) {
            isExpanded.value = expanded;
          },
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Goal: ${goal != null ? goal.toStringAsFixed(1) : 'Not set'} $unit',
                    style: AdminTheme.textStyles['body'],
                  ),
                  Text(
                    'Current: ${current != null ? current.toStringAsFixed(1) : 'Not set'} $unit',
                    style: AdminTheme.textStyles['body'],
                  ),
                  SizedBox(height: 8.h),
                  LinearProgressIndicator(
                    value: goal != null && current != null && goal > 0 ? current / goal : 0,
                    backgroundColor: AdminTheme.colors['inputBackground'],
                    valueColor: AlwaysStoppedAnimation<Color>(AdminTheme.colors['primary']!),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}