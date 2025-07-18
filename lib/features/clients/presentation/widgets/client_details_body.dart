import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_details_controller.dart';
import 'client-progress_section.dart';
import 'client_details_card_wrapper.dart';
import 'client_plan_section.dart';

class ClientDetailsBody extends StatelessWidget {
  const ClientDetailsBody({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();

    return Obx(() {
      if (controller.isLoading.value) {
        return Center(
          child: CircularProgressIndicator(color: AdminTheme.colors['primary']),
        );
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
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
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
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
