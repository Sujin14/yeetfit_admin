import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/theme/theme.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, Admin',
              style: AdminTheme.textStyles['heading']!.copyWith(
                color: AdminTheme.colors['textPrimary'],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Manage your clients and their progress',
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['textSecondary'],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
