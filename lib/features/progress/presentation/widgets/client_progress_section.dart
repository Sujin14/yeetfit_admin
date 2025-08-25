import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../clients/presentation/controllers/client_details_controller.dart';

class ClientProgressSection extends StatelessWidget {
  const ClientProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    final isWeb =
        MediaQuery.of(context).size.width > 600; // Threshold for web view

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Daily Progress',
            style: AdminTheme.textStyles['title']!.copyWith(
              fontSize: isWeb ? 16.0 : 18.sp, // Constrain title font size
            ),
          ),
          SizedBox(height: 8.h),
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
              title: Text(
                'View Daily Progress',
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['textPrimary'],
                  fontSize: isWeb ? 14.0 : 16.sp, // Constrain font size
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: isWeb ? 14.0 : 16.w, // Constrain icon size for web
                color: AdminTheme.colors['textSecondary'],
              ),
              onTap: () {
                print(
                  'ClientProgressSection: Navigating to /home/client-progress with UID: ${controller.uid.value}',
                );
                Get.toNamed(
                  '/home/client-progress',
                  arguments: {'uid': controller.uid.value},
                  preventDuplicates: true,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
