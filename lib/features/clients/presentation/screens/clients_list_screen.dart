import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_appbar.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_controller.dart';
import '../widgets/client_list_item.dart';

class ClientsListScreen extends GetView<ClientController> {
  const ClientsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final goal = (Get.arguments?['goal'] as String?) ?? 'weight loss';
    controller.fetchClients(goal);

    return Obx(
      () => Scaffold(
        appBar: CustomAppBar(title: '$goal Clients'),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: controller.error.value.isNotEmpty
              ? CustomErrorWidget(
                  message: controller.error.value,
                  onRetry: () => controller.fetchClients(goal),
                )
              : controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : controller.clients.isEmpty
              ? Center(
                  child: Text(
                    'No clients found for $goal',
                    style: AdminTheme.textStyles['body']!.copyWith(
                      color: AdminTheme.colors['textSecondary'],
                    ),
                  ),
                )
              : ListView.separated(
                  itemCount: controller.clients.length,
                  separatorBuilder: (context, index) => SizedBox(height: 8.h),
                  itemBuilder: (context, index) {
                    return ClientListItem(client: controller.clients[index]);
                  },
                ),
        ),
      ),
    );
  }
}
