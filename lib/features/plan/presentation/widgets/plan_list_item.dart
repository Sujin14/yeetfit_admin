import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:lottie/lottie.dart';
import '../../../../core/widgets/confirmation_dialog.dart';
import '../../data/model/plan_model.dart';
import '../../../../core/theme/theme.dart';
import '../screens/plan_preview_screen.dart';

class PlanListItem extends StatelessWidget {
  final PlanModel plan;
  final VoidCallback onDelete;
  final VoidCallback onEdit;
  final bool isFirst;

  const PlanListItem({
    super.key,
    required this.plan,
    required this.onDelete,
    required this.onEdit,
    required this.isFirst,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600 && screenWidth < 1024;
    final isDesktop = screenWidth >= 1024;

    double maxWidth = double.infinity;
    if (isTablet) maxWidth = 600;
    if (isDesktop) maxWidth = 800;

    return Center(
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
                  borderRadius: BorderRadius.circular(12.r),
                ),
                SlidableAction(
                  onPressed: (_) async {
                    final confirm = await showConfirmationDialog(plan.title);
                    if (confirm == true) onDelete();
                  },
                  backgroundColor: AdminTheme.colors['deleteIcon']!,
                  foregroundColor: AdminTheme.colors['surface'],
                  icon: Icons.delete,
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ],
            ),
            child: GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => PlanPreviewScreen(plan: plan),
                  ),
                );
              },
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ListTile(
                  contentPadding: EdgeInsets.all(16.w),
                  leading: Icon(
                    plan.type == 'diet'
                        ? Icons.restaurant
                        : Icons.fitness_center,
                    color: AdminTheme.colors['primary'],
                    size: 28,
                  ),
                  title: Text(
                    plan.title,
                    style: AdminTheme.textStyles['title']!.copyWith(
                      color: AdminTheme.colors['textPrimary'],
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  trailing: isFirst
                      ? SizedBox(
                          width: 60,
                          height: 60,
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
      ),
    );
  }
}
