import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_controller.dart';
import '../widgets/client_details_card.dart';
import '../widgets/progress_card.dart';

class ClientDetailsScreen extends GetView<ClientController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final uid = Get.arguments?['uid'] as String?;

    if (uid == null || uid.isEmpty) {
      return Scaffold(
        appBar: const CustomAppBar(title: 'Client Details'),
        body: Center(
          child: Text(
            'Invalid client ID provided',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
        ),
      );
    }

    // Fetch client details after the build phase if needed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (controller.selectedClient.value == null ||
          controller.selectedClient.value!.uid != uid) {
        controller.fetchClientDetails(uid);
      }
    });

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(
          title: controller.selectedClient.value?.name ?? 'Loading...',
          leading: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: BoxConstraints.tight(Size(40.w, 40.h)),
                icon: Icon(
                  Icons.arrow_back,
                  color: AdminTheme.colors['textPrimary'],
                  size: 20.w,
                ),
                onPressed: () => Get.back(),
              ),
              SizedBox(width: 4.w),
              Flexible(
                child: CircleAvatar(
                  radius: 14.r,
                  backgroundColor: AdminTheme.colors['primary']?.withOpacity(
                    0.1,
                  ),
                  backgroundImage:
                      controller
                              .selectedClient
                              .value
                              ?.profilePicture
                              ?.isNotEmpty ==
                          true
                      ? NetworkImage(
                          controller.selectedClient.value!.profilePicture!,
                        )
                      : null,
                  child:
                      controller
                              .selectedClient
                              .value
                              ?.profilePicture
                              ?.isEmpty !=
                          false
                      ? Text(
                          controller.selectedClient.value?.name.isNotEmpty ==
                                  true
                              ? controller.selectedClient.value!.name[0]
                              : '',
                          style: AdminTheme.textStyles['body']!.copyWith(
                            color: AdminTheme.colors['textPrimary'],
                            fontSize: 12.sp,
                          ),
                        )
                      : null,
                ),
              ),
            ],
          ),
        ),
        body: Padding(
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
                      ClientDetailsCard(
                        client: controller.selectedClient.value!,
                      ),
                      SizedBox(height: 16.h),
                      Text(
                        'Daily Progress',
                        style: AdminTheme.textStyles['title'],
                      ),
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
        ),
      ),
    );
  }
}
