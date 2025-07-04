import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../data/models/plan_model.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final String type;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const PlanListItem({
    super.key,
    required this.plan,
    required this.type,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    // Safely extract description from details
    String description = 'No description';
    try {
      if (type == 'diet') {
        final meals = plan.details['meals'] as List<dynamic>?;
        description = meals != null && meals.isNotEmpty
            ? (meals[0] as Map<String, dynamic>)['food']?.toString() ??
                  'No meal name'
            : 'No meals';
      } else {
        final exercises = plan.details['exercises'] as List<dynamic>?;
        description = exercises != null && exercises.isNotEmpty
            ? (exercises[0] as Map<String, dynamic>)['name']?.toString() ??
                  'No exercise name'
            : 'No exercises';
      }
    } catch (e) {
      print('PlanListItem: Error parsing details for plan ${plan.id}: $e');
    }

    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: ListTile(
        title: Text(
          plan.title,
          style: AdminTheme.textStyles['body']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
          ),
        ),
        subtitle: Text(
          description,
          style: AdminTheme.textStyles['body']!.copyWith(
            color: AdminTheme.colors['textSecondary'],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: AdminTheme.colors['primary'],
                size: 20.w,
              ),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(
                Icons.delete,
                color: AdminTheme.colors['error'],
                size: 20.w,
              ),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
