import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/routes/app_routes.dart';
import '../../../../core/theme/theme.dart';
import '../../../clients/presentation/controllers/client_details_controller.dart';

class ClientPlansSection extends StatelessWidget {
  const ClientPlansSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    final isWeb =
        MediaQuery.of(context).size.width > 600;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Plan Management',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
              fontSize: isWeb ? 16.0 : 18.sp, // Constrain title font size
            ),
          ),
          SizedBox(height: 8.h),
          ListTile(
            leading: Image.asset(
              'assets/images/diet.png',
              width: isWeb ? 40.0 : 50.w, // Constrain image size for web
              height: isWeb ? 40.0 : 50.h,
            ),
            title: Text(
              'Diet Plans',
              style: AdminTheme.textStyles['body']!.copyWith(
                fontSize: isWeb ? 14.0 : 16.sp, // Constrain font size
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isWeb ? 14.0 : 16.w, // Constrain icon size for web
              color: AdminTheme.colors['textSecondary'],
            ),
            onTap: () => AppRoutes.debounceNavigate(
              '/home/plan-list',
              arguments: {'uid': controller.uid.value, 'type': 'diet'},
            ),
          ),
          ListTile(
            leading: Image.asset(
              'assets/images/workouts.png',
              width: isWeb ? 40.0 : 50.w, // Constrain image size for web
              height: isWeb ? 40.0 : 50.h,
            ),
            title: Text(
              'Workout Plans',
              style: AdminTheme.textStyles['body']!.copyWith(
                fontSize: isWeb ? 14.0 : 16.sp, // Constrain font size
              ),
            ),
            trailing: Icon(
              Icons.arrow_forward_ios,
              size: isWeb ? 14.0 : 16.w, // Constrain icon size for web
              color: AdminTheme.colors['textSecondary'],
            ),
            onTap: () => AppRoutes.debounceNavigate(
              '/home/plan-list',
              arguments: {'uid': controller.uid.value, 'type': 'workout'},
            ),
          ),
        ],
      ),
    );
  }
}
