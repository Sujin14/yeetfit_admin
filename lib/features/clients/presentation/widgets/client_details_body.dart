import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/utils/responsive_layout.dart';
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
        return const _ShimmerLoading();
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
        padding: LayoutConstants.screenPadding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ClientDetailsCardWrapper(),
            SizedBox(height: LayoutConstants.sectionSpacing),
            const ClientProgressSection(),
            SizedBox(height: LayoutConstants.sectionSpacing),
            const ClientPlansSection(),
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
  const _ShimmerLoading();

  Widget _buildShimmerCard({required Widget child}) {
    return Shimmer.fromColors(
      baseColor: AdminTheme.colors['black']!.withOpacity(0.1),
      highlightColor: AdminTheme.colors['surface']!.withOpacity(0.3),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildShimmerCard(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Container(
                      width: 72.w,
                      height: 72.w,
                      decoration: BoxDecoration(
                        color: AdminTheme.colors['onPrimary'],
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(height: 16.h),

                    Container(
                      height: 16.h,
                      width: 120.w,
                      decoration: BoxDecoration(
                        color: AdminTheme.colors['onPrimary'],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 12.h),

                    ...List.generate(
                      5,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 6.h),
                        child: Container(
                          height: 14.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AdminTheme.colors['onPrimary'],
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          _buildShimmerCard(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  children: [
                    Container(
                      height: 18.h,
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: AdminTheme.colors['onPrimary'],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Container(
                      height: 100.h,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AdminTheme.colors['onPrimary'],
                        borderRadius: BorderRadius.circular(8.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 16.h),

          _buildShimmerCard(
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: 18.h,
                      width: 140.w,
                      decoration: BoxDecoration(
                        color: AdminTheme.colors['onPrimary'],
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    ...List.generate(
                      3,
                      (index) => Padding(
                        padding: EdgeInsets.symmetric(vertical: 8.h),
                        child: Container(
                          height: 40.h,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: AdminTheme.colors['onPrimary'],
                            borderRadius: BorderRadius.circular(8.r),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
