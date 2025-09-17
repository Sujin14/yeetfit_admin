import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../clients/presentation/controllers/client_details_controller.dart';

class ClientPlansSection extends StatelessWidget {
  const ClientPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    final isWeb = MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text(
              'Plan Management',
              style: AdminTheme.textStyles['title'],
            ),
          ),
          SizedBox(height: LayoutConstants.itemSpacing),

          // Diet Plans Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              leading: Image.asset(
                'assets/images/diet.png',
                width: isWeb ? 40.0 : 40.w,
                height: isWeb ? 40.0 : 40.h,
              ),
              title: Text(
                'Diet Plans',
                style: AdminTheme.textStyles['body']!.copyWith(
                  fontSize: isWeb ? 14.0 : 16.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: isWeb ? 14.0 : 16.w,
                color: AdminTheme.colors['textSecondary'],
              ),
              onTap: () => AppRoutes.debounceNavigate(
                '/home/plan-list',
                arguments: {'uid': controller.uid.value, 'type': 'diet'},
              ),
            ),
          ),

          SizedBox(height: LayoutConstants.itemSpacing),

          // Workout Plans Card
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(
                horizontal: 16.w,
                vertical: 8.h,
              ),
              leading: Image.asset(
                'assets/images/workouts.png',
                width: isWeb ? 40.0 : 40.w,
                height: isWeb ? 40.0 : 40.h,
              ),
              title: Text(
                'Workout Plans',
                style: AdminTheme.textStyles['body']!.copyWith(
                  fontSize: isWeb ? 14.0 : 16.sp,
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: isWeb ? 14.0 : 16.w,
                color: AdminTheme.colors['textSecondary'],
              ),
              onTap: () => AppRoutes.debounceNavigate(
                '/home/plan-list',
                arguments: {'uid': controller.uid.value, 'type': 'workout'},
              ),
            ),
          ),
        ],
      ),
    );
  }
}
