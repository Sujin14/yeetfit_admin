import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';
import '../../data/models/progress_model.dart';

class ProgressCard extends StatelessWidget {
  final ProgressModel progress;

  const ProgressCard({super.key, required this.progress});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8.h),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Date: ${progress.date.toString().split(' ')[0]}',
              style: AdminTheme.textStyles['body'],
            ),
            SizedBox(height: 4.h),
            Text(
              'Steps: ${progress.steps}',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Water Intake: ${progress.waterIntake.toStringAsFixed(1)} L',
              style: AdminTheme.textStyles['body'],
            ),
            Text(
              'Calories Burned: ${progress.calorieIntake.toStringAsFixed(1)} kcal',
              style: AdminTheme.textStyles['body'],
            ),
          ],
        ),
      ),
    );
  }
}
