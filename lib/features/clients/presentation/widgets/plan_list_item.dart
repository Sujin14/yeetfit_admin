import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/plan_model.dart';
import '../../../../core/theme/theme.dart';

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
      margin: EdgeInsets.symmetric(vertical: 8.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      child: Padding(
        padding: EdgeInsets.all(16.w),
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
              ...?(plan.details['meals'] as List?)?.map((meal) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      meal['name'] ?? 'Unnamed Meal',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['textSecondary'],
                      ),
                    ),
                    ...(meal['foods'] as List).map(
                      (food) => Text(
                        '${food['quantity']} - ${food['calories']} kcal',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ] else ...[
              ...?(plan.details['exercises'] as List?)?.map((exercise) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise['name'] ?? 'Unnamed Exercise',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['textSecondary'],
                      ),
                    ),
                    Text(
                      'Reps: ${exercise['reps']}, Sets: ${exercise['sets']}',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['textSecondary'],
                      ),
                    ),
                    if (exercise['videoUrl']?.isNotEmpty ?? false)
                      Text(
                        'Video: ${exercise['videoUrl']}',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                  ],
                );
              }).toList(),
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
