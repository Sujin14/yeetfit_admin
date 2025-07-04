import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../controllers/client_controller.dart';
import '../controllers/client_details_controller.dart';
import '../widgets/client_details_content.dart';
import '../widgets/client_details_leading.dart';
import '../../../../core/theme/theme.dart';

class ClientDetailsScreen extends GetView<ClientDetailsController> {
  const ClientDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize ClientDetailsController
    Get.put(ClientDetailsController());

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
          leading: ClientDetailsLeading(
            controller: Get.find<ClientController>(),
          ),
          actions: [
            IconButton(
              icon: Icon(
                Icons.restaurant_menu,
                color: AdminTheme.colors['textPrimary'],
                size: 20.w,
              ),
              onPressed: controller.navigateToDietPlanForm,
            ),
            IconButton(
              icon: Icon(
                Icons.fitness_center,
                color: AdminTheme.colors['textPrimary'],
                size: 20.w,
              ),
              onPressed: controller.navigateToWorkoutPlanForm,
            ),
          ],
        ),
        body: controller.isInvalidUid.value
            ? Center(
                child: Text(
                  'Invalid client ID provided',
                  style: AdminTheme.textStyles['body']!.copyWith(
                    color: AdminTheme.colors['textSecondary'],
                  ),
                ),
              )
            : ClientDetailsContent(
                controller: Get.find<ClientController>(),
                uid: controller.uid.value,
              ),
      ),
    );
  }
}
