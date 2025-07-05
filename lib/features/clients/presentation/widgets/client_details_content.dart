import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_card.dart';
import '../widgets/client_plan_actions.dart';
import '../widgets/progress_card.dart';

class ClientDetailsContent extends StatelessWidget {
  final ClientDetailsController controller;
  final String uid;

  const ClientDetailsContent({
    super.key,
    required this.controller,
    required this.uid,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: controller.error.value.isNotEmpty
          ? CustomErrorWidget(
              message: controller.error.value,
              onRetry: () => controller.fetchClientDetails(uid),
            )
          : controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.selectedClient.value == null
          ? Center(
              child: Text(
                'Client not found',
                style: AdminTheme.textStyles['body']!.copyWith(
                  color: AdminTheme.colors['textSecondary'],
                ),
              ),
            )
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClientDetailsCard(client: controller.selectedClient.value!),
                  SizedBox(height: 16.h),
                  ClientPlanActions(uid: uid),
                  SizedBox(height: 16.h),
                  Text('Daily Progress', style: AdminTheme.textStyles['title']),
                  if (controller.progress.isEmpty)
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 8.h),
                      child: Text(
                        'No progress data available',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                    ),
                  ...controller.progress.map(
                    (progress) => ProgressCard(progress: progress),
                  ),
                ],
              ),
            ),
    );
  }
}
