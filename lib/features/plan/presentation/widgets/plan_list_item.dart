import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import '../../data/model/plan_model.dart';
import '../../../../core/theme/theme.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isFirst; // New parameter to indicate if this is the first item

  const PlanListItem({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
    required this.isFirst, // Required parameter
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    // Constrain max width for tablet/desktop
    double maxWidth = double.infinity;
    if (isTablet) {
      maxWidth = 600; // tablet width
    } else if (isDesktop) {
      maxWidth = 800; // desktop width
    }

    return Center(
      // keeps the card centered on larger screens
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
          child: Slidable(
            key: ValueKey(plan.id),
            endActionPane: ActionPane(
              motion: const StretchMotion(),
              extentRatio: 0.5,
              children: [
                SlidableAction(
                  onPressed: (_) => onEdit(),
                  backgroundColor: AdminTheme.colors['editIcon']!,
                  foregroundColor: AdminTheme.colors['surface'],
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
                          'Are you sure you want to delete "${plan.title}"?',
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
                              style: TextStyle(
                                color: AdminTheme.colors['error'],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                    if (confirm == true) onDelete();
                  },
                  backgroundColor: AdminTheme.colors['deleteIcon']!,
                  foregroundColor: AdminTheme.colors['surface'],
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
                  plan.type == 'diet' ? Icons.restaurant : Icons.fitness_center,
                  color: AdminTheme.colors['primary'],
                  size: 24, // keep fixed, no scaling with w/h
                ),
                title: Text(
                  plan.title,
                  textAlign: TextAlign.start,
                  style: AdminTheme.textStyles['title']!.copyWith(
                    color: AdminTheme.colors['textPrimary'],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                trailing: isFirst
                    ? SizedBox(
                        width: 80, // fixed sizes (don’t scale with screen)
                        height: 80,
                        child: Lottie.asset(
                          'assets/animations/left_swipe.json',
                          repeat: true,
                          animate: true,
                        ),
                      )
                    : null,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
