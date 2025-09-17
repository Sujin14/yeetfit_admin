import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/responsive_layout.dart';
import '../../../clients/presentation/controllers/client_details_controller.dart';

class ClientProgressSection extends StatelessWidget {
  const ClientProgressSection({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    final isWeb =
        MediaQuery.of(context).size.width > 600; // Threshold for web view

    return Padding(
  padding: EdgeInsets.zero,
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.all(6.0),
        child: Text(
          'Daily Progress',
          style: AdminTheme.textStyles['title'],
        ),
      ),
      SizedBox(height: LayoutConstants.itemSpacing),
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
