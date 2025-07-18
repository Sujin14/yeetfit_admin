import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../controllers/client_details_controller.dart';

class ClientPlansSection extends StatelessWidget {
  const ClientPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Management',
          style: AdminTheme.textStyles['title']!.copyWith(color: AdminTheme.colors['textPrimary']),
        ),
        SizedBox(height: 8.h),
        ListTile(
          leading: Image.asset('assets/images/diet.jpg', width: 24.w, height: 24.h, color: AdminTheme.colors['primary']),
          title: Text('Diet Plans', style: AdminTheme.textStyles['body']),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AdminTheme.colors['textSecondary']),
          onTap: () => controller.navigateToManageDietPlans(),
        ),
        ListTile(
          leading: Image.asset('assets/images/workouts.jpg', width: 24.w, height: 24.h, color: AdminTheme.colors['primary']),
          title: Text('Workout Plans', style: AdminTheme.textStyles['body']),
          trailing: Icon(Icons.arrow_forward_ios, size: 16, color: AdminTheme.colors['textSecondary']),
          onTap: () => controller.navigateToManageWorkoutPlans(),
        ),
      ],
    );
  }
}
