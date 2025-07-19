import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../data/model/plan_model.dart';
import '../../../../core/theme/theme.dart';

class PlanListItem extends StatefulWidget {
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
  _PlanListItemState createState() => _PlanListItemState();
}

class _PlanListItemState extends State<PlanListItem> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Slidable(
        key: ValueKey(widget.plan.id),
        endActionPane: ActionPane(
          motion: const StretchMotion(),
          extentRatio: 0.5,
          children: [
            SlidableAction(
              onPressed: (_) => widget.onEdit(),
              backgroundColor: AdminTheme.colors['editIcon'] ?? Colors.blue,
              foregroundColor: AdminTheme.colors['surface'] ?? Colors.white,
              icon: Icons.edit,
              label: 'Edit',
            ),
            SlidableAction(
              onPressed: (_) async {
                final confirm = await Get.dialog<bool>(
                  AlertDialog(
                    title: Text(
                      'Confirm Delete',
                      style: AdminTheme.textStyles['title'],
                    ),
                    content: Text(
                      'Are you sure you want to delete "${widget.plan.title}"?',
                      style: AdminTheme.textStyles['body'],
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Get.back(result: false),
                        child: Text(
                          'Cancel',
                          style: AdminTheme.textStyles['body'],
                        ),
                      ),
                      TextButton(
                        onPressed: () => Get.back(result: true),
                        child: Text(
                          'Delete',
                          style: TextStyle(color: AdminTheme.colors['error']),
                        ),
                      ),
                    ],
                  ),
                );
                if (confirm == true) widget.onDelete();
              },
              backgroundColor: AdminTheme.colors['deleteIcon'] ?? Colors.red,
              foregroundColor: AdminTheme.colors['surface'] ?? Colors.white,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: ListTile(
            leading: Icon(
              widget.plan.type == 'diet' ? Icons.restaurant : Icons.fitness_center,
              color: AdminTheme.colors['primary'],
              size: 24.w,
            ),
            title: Text(
              widget.plan.title,
              textAlign: TextAlign.center,
              style: AdminTheme.textStyles['title']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
                fontWeight: FontWeight.w600,
              ),
            ),
            trailing: SizedBox(
              width: 50.w,
              height: 100.h,
              child: Lottie.asset(
                'assets/animations/left_swipe.json',
                repeat: true,
                controller: _controller,
              ),
            ),
          ),
        ),
      ),
    );
  }
}