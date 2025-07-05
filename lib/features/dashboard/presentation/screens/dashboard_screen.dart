import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_list_tile.dart';

class DashboardScreen extends GetView<DashboardController> {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: const CustomAppBar(title: 'Admin Dashboard'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: controller.error.value.isNotEmpty
              ? CustomErrorWidget(
                  message: controller.error.value,
                  onRetry: controller.fetchStats,
                )
              : controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.stats.value == null
              ? Center(
                  child: Text(
                    'No data available',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['textSecondary'],
                    ),
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const DashboardHeader(),
                    SizedBox(height: 16.h),
                    Text(
                      'Client Statistics',
                      style: AdminTheme.textStyles['title'],
                    ),
                    SizedBox(height: 8.h),
                    DashboardListTile(
                      image: 'assets/images/weight_loss.png',
                      title: 'Weight Loss Clients',
                      count: controller.stats.value!.weightLossCount,
                      onTap: () => Get.toNamed(
                        '/home/clients',
                        arguments: {'goal': 'Weight Loss'},
                      ),
                    ),
                    DashboardListTile(
                      image: 'assets/images/weight_gain.png',
                      title: 'Weight Gain Clients',
                      count: controller.stats.value!.weightGainCount,
                      onTap: () => Get.toNamed(
                        '/home/clients',
                        arguments: {'goal': 'Weight Gain'},
                      ),
                    ),
                    DashboardListTile(
                      image: 'assets/images/musscle_building.png',
                      title: 'Muscle Building Clients',
                      count: controller.stats.value!.muscleBuildingCount,
                      onTap: () => Get.toNamed(
                        '/home/clients',
                        arguments: {'goal': 'Muscle Building'},
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
