import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme.dart';
import '../../data/model/plan_model.dart';

class PlanSummaryCard extends StatelessWidget {
  final PlanModel plan;
  final bool isWorkout;
  const PlanSummaryCard({
    super.key,
    required this.plan,
    required this.isWorkout,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 4,
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          children: [
            Icon(
              isWorkout ? Icons.local_fire_department : Icons.fastfood,
              color: AdminTheme.colors['primary'],
              size: 28.sp,
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Text(
                isWorkout
                    ? "${plan.totalCalories} cal to burn"
                    : "${plan.totalCalories} cal to eat",
                style: AdminTheme.textStyles['body']!.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
