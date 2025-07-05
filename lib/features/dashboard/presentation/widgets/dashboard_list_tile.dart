import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/controllers/bottom_nav_controller.dart';
import '../../../../core/theme/theme.dart';
import '../../../clients/presentation/controllers/client_list_controller.dart';

class DashboardListTile extends StatelessWidget {
  final String image;
  final String title;
  final int count;
  final VoidCallback? onTap;

  const DashboardListTile({
    super.key,
    required this.image,
    required this.title,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bottomNavController = Get.put(BottomNavController());
    final clientController = Get.find<ClientListController>();

    return Card(
      margin: EdgeInsets.symmetric(vertical: 4.h),
      child: ListTile(
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        leading: Image.asset(
          image,
          width: 24.w,
          height: 24.h,
          color: AdminTheme.colors['primary'],
        ),
        title: Text(
          title,
          style: AdminTheme.textStyles['title']!.copyWith(
            color: AdminTheme.colors['textPrimary'],
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              count.toString(),
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['primary'],
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(width: 8.w),
            Icon(
              Icons.arrow_forward_ios,
              size: 16.w,
              color: AdminTheme.colors['textSecondary'],
            ),
          ],
        ),
        onTap:
            onTap ??
            () {
              bottomNavController.changeIndex(1);
              clientController.fetchClients(title.replaceAll(' Clients', ''));
            },
      ),
    );
  }
}
