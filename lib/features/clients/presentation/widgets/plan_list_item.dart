import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../data/models/plan_model.dart';
import '../../../../core/theme/theme.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  const PlanListItem({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 4.h),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: ListTile(
        title: Text(
          plan.title,
          style: AdminTheme.textStyles['body']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
            fontWeight: FontWeight.w600,
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: Icon(Icons.edit, color: AdminTheme.colors['primary']),
              onPressed: onEdit,
            ),
            IconButton(
              icon: Icon(Icons.delete, color: AdminTheme.colors['error']),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }
}
