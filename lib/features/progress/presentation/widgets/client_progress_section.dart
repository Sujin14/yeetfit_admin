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

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Daily Progress', style: AdminTheme.textStyles['title']),
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
                ),
              ),
              trailing: Icon(
                Icons.arrow_forward_ios,
                size: 16.w,
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
