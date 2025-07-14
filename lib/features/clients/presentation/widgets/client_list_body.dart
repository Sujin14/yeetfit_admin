import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_list_controller.dart';
import 'client_list_item.dart';

class ClientsListBody extends StatelessWidget {
  final String goal;
  const ClientsListBody({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<ClientListController>(tag: goal);

    return Obx(() {
      if (controller.error.value.isNotEmpty) {
        return CustomErrorWidget(
          message: controller.error.value,
          onRetry: () => controller.retryFetchClients(),
        );
      } else if (controller.isLoading.value) {
        return const Center(child: CircularProgressIndicator());
      } else if (controller.filteredClients.isEmpty) {
        return Center(
          child: Text(
            'No clients found for $goal',
            style: AdminTheme.textStyles['body']!.copyWith(
              color: AdminTheme.colors['textSecondary'],
            ),
          ),
        );
      } else {
        return ListView.separated(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          itemCount: controller.filteredClients.length,
          separatorBuilder: (_, __) => SizedBox(height: 8.h),
          itemBuilder: (context, index) {
            final client = controller.filteredClients[index];
            return AnimatedOpacity(
              duration: Duration(milliseconds: 300 + index * 50),
              opacity: 1,
              child: ClientListItem(client: client),
            );
          },
        );
      }
    });
  }
}
