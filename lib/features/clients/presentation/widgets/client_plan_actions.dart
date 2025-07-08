import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../controllers/plan_controller.dart';

class ClientPlanActions extends StatelessWidget {
  final String uid;

  const ClientPlanActions({super.key, required this.uid});

  @override
  Widget build(BuildContext context) {
    // Ensure PlanController is initialized or reused
    final PlanController controller = Get.put(
      PlanController(),
      tag:
          'plan-$uid', // Use a unique tag to reuse the controller for this user
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Plan Management',
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
          ),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.restaurant_menu,
                  size: 18.w,
                  color: AdminTheme.colors['textPrimary'],
                ),
                label: Text(
                  'Add Diet',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textPrimary'],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.colors['primary'],
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  print(
                    'ClientPlanActions: Navigating to /home/plan-form with type: diet, uid: $uid',
                  );
                  // Initialize form with correct arguments
                  controller.initializeForm();
                  Get.toNamed(
                    '/home/plan-form',
                    arguments: {'uid': uid, 'mode': 'add', 'type': 'diet'},
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(
                  Icons.restaurant_menu,
                  size: 18.w,
                  color: AdminTheme.colors['textSecondary'],
                ),
                label: Text(
                  'Manage Diets',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AdminTheme.colors['primary']!),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  print(
                    'ClientPlanActions: Navigating to /home/diet-plan-management with uid: $uid',
                  );
                  // Ensure controller is initialized with correct userId and type
                  controller.userId.value = uid;
                  controller.planType.value = 'diet';
                  controller.fetchPlans();
                  Get.toNamed(
                    '/home/diet-plan-management',
                    arguments: {'uid': uid, 'type': 'diet'},
                  );
                },
              ),
            ),
          ],
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(
                  Icons.fitness_center,
                  size: 18.w,
                  color: AdminTheme.colors['textPrimary'],
                ),
                label: Text(
                  'Add Workout',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textPrimary'],
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AdminTheme.colors['primary'],
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  print(
                    'ClientPlanActions: Navigating to /home/plan-form with type: workout, uid: $uid',
                  );
                  // Initialize form with correct arguments
                  controller.initializeForm();
                  Get.toNamed(
                    '/home/plan-form',
                    arguments: {'uid': uid, 'mode': 'add', 'type': 'workout'},
                  );
                },
              ),
            ),
            SizedBox(width: 8.w),
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(
                  Icons.fitness_center,
                  size: 18.w,
                  color: AdminTheme.colors['textSecondary'],
                ),
                label: Text(
                  'Manage Workouts',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AdminTheme.colors['primary']!),
                  padding: EdgeInsets.symmetric(
                    vertical: 12.h,
                    horizontal: 16.w,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                onPressed: () {
                  print(
                    'ClientPlanActions: Navigating to /home/workout-plan-management with uid: $uid',
                  );
                  // Ensure controller is initialized with correct userId and type
                  controller.userId.value = uid;
                  controller.planType.value = 'workout';
                  controller.fetchPlans();
                  Get.toNamed(
                    '/home/workout-plan-management',
                    arguments: {'uid': uid, 'type': 'workout'},
                  );
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}
