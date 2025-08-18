import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../../../plan/presentation/widgets/client_plan_section.dart';
import '../../../progress/presentation/widgets/client_progress_section.dart';
import '../controllers/client_details_controller.dart';
import 'client_details_card_wrapper.dart';

class ClientDetailsBody extends StatelessWidget {
  const ClientDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return _ShimmerLoading();
      }

      if (controller.isInvalidUid.value) {
        return _InvalidUidWidget(error: controller.error.value);
      }

      if (controller.error.value.isNotEmpty) {
        return CustomErrorWidget(
          message: controller.error.value,
          onRetry: () => controller.fetchClientDetails(controller.uid.value),
        );
      }

      if (controller.selectedClient.value == null) {
        return Center(
          child: Text(
            'Client not found',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
        );
      }

      return SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            ClientDetailsCardWrapper(),
            SizedBox(height: 16),
            ClientProgressSection(),
            SizedBox(height: 16),
            ClientPlansSection(),
          ],
        ),
      );
    });
  }
}

class _InvalidUidWidget extends StatelessWidget {
  final String error;

  const _InvalidUidWidget({required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Invalid client ID provided',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'Error: $error',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['error'],
            ),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(
            onPressed: () => Get.back(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AdminTheme.colors['primary'],
            ),
            child: Text(
              'Go Back',
              style: AdminTheme.textStyles['body']!.copyWith(
                color: AdminTheme.colors['onPrimary'],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ShimmerLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AdminTheme.colors['black']!,
      highlightColor: AdminTheme.colors['surface']!,
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              height: 200.h,
              decoration: BoxDecoration(
                color: AdminTheme.colors['onPrimary'],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: AdminTheme.colors['onPrimary'],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            SizedBox(height: 16.h),
            Container(
              width: double.infinity,
              height: 150.h,
              decoration: BoxDecoration(
                color: AdminTheme.colors['onPrimary'],
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
