import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_content.dart';
import '../widgets/client_details_leading.dart';
import '../../../../core/theme/theme.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientDetailsController>();
    if (controller.uid.value.isEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        print('ClientDetailsScreen: Triggering reinitialize');
        controller.reinitialize();
      });
    }

    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: Text(
            controller.clientName.value ?? 'Loading...',
            style: AdminTheme.textStyles['title']!.copyWith(
              color: AdminTheme.colors['textPrimary'],
            ),
          ),
          backgroundColor: AdminTheme.colors['surface'],
          elevation: 2,
          leading: ClientDetailsLeading(controller: controller),
        ),
        body: controller.isLoading.value
            ? Center(
                child: CircularProgressIndicator(
                  color: AdminTheme.colors['primary'],
                ),
              )
            : controller.isInvalidUid.value
            ? Center(
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
                      'Error: ${controller.error.value}',
                      style: AdminTheme.textStyles['body']!.copyWith(
                        color: AdminTheme.colors['error'],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    ElevatedButton(
                      onPressed: () {
                        print('ClientDetailsScreen: Going back');
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AdminTheme.colors['primary'],
                      ),
                      child: Text(
                        'Go Back',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textPrimary'],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : ClientDetailsContent(
                controller: controller,
                uid: controller.uid.value,
              ),
      ),
    );
  }
}
