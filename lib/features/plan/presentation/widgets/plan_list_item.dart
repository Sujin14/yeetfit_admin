import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import '../../data/model/plan_model.dart';
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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Slidable(
        key: ValueKey(plan.id),
        endActionPane: ActionPane(
          motion: const DrawerMotion(),
          extentRatio: 0.5, // adjust as needed
          children: [
            SlidableAction(
              onPressed: (_) => onEdit(),
              backgroundColor: AdminTheme.colors['primary'] ?? Colors.blue,
              foregroundColor: AdminTheme.colors['surface'] ?? Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text('Confirm Delete', style: AdminTheme.textStyles['title']),
                    content: Text(
                      'Are you sure you want to delete "${plan.title}"?',
                      style: AdminTheme.textStyles['body'],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text('Cancel', style: AdminTheme.textStyles['body']),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text('Delete', style: TextStyle(color: AdminTheme.colors['error'])),
                      ),
                    ],
                  ),
                );
                if (confirm == true) onDelete();
              },
              backgroundColor: AdminTheme.colors['error'] ?? Colors.red,
              foregroundColor: AdminTheme.colors['surface'] ?? Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
          child: ListTile(
            title: Text(
              plan.title,
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: Text(
              plan.details['description'] ?? '',
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textSecondary'],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
