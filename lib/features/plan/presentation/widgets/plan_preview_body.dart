import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../../core/theme/theme.dart';
import '../../data/model/plan_model.dart';
import 'plan_summary_card.dart';
import 'diet_meal_list.dart';
import 'workout_list.dart';

class PlanPreviewBody extends StatelessWidget {
  final PlanModel plan;
  const PlanPreviewBody({super.key, required this.plan});

  @override
  Widget build(BuildContext context) {
    final isWorkout = plan.type == 'workout';

    return Scaffold(
      backgroundColor: AdminTheme.colors['background'],
      appBar: AppBar(
        title: Text(plan.title),
        backgroundColor: AdminTheme.colors['surface'],
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PlanSummaryCard(plan: plan, isWorkout: isWorkout),
            SizedBox(height: 20.h),
            if (isWorkout)
              WorkoutList(exercises: plan.details['exercises'] as List? ?? [])
            else
              DietMealList(meals: plan.details['meals'] as Map<String, dynamic>? ?? {}),
          ],
        ),
      ),
    );
  }
}
