import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../../core/theme/theme.dart';
import '../../../../core/widgets/custom_error_widget.dart';
import '../controllers/client_list_controller.dart';
import '../widgets/client_list_item.dart';
import '../../../../core/widgets/custom_text_field.dart';

class ClientsListScreen extends GetView<ClientListController> {
  final String goal;

  const ClientsListScreen({super.key, required this.goal});

  @override
  Widget build(BuildContext context) {
    final searchController = TextEditingController();
    controller.fetchClients(goal);

    return Obx(
      () => Scaffold(
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
          child: Column(
            children: [
              CustomTextField(
                controller: searchController,
                labelText: 'Search Clients by Name',
                hintText: 'Enter client name',
                onChanged: (value) {
                  controller.filterClients(value, goal);
                },
              ),
              SizedBox(height: 16.h),
              controller.error.value.isNotEmpty
                  ? CustomErrorWidget(
                      message: controller.error.value,
                      onRetry: () => controller.fetchClients(goal),
                    )
                  : controller.isLoading.value
                  ? const Center(child: CircularProgressIndicator())
                  : controller.filteredClients.isEmpty
                  ? Center(
                      child: Text(
                        'No clients found for $goal',
                        style: AdminTheme.textStyles['body']!.copyWith(
                          color: AdminTheme.colors['textSecondary'],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.separated(
                        itemCount: controller.filteredClients.length,
                        separatorBuilder: (context, index) =>
                            SizedBox(height: 8.h),
                        itemBuilder: (context, index) {
                          return ClientListItem(
                            client: controller.filteredClients[index],
                          );
                        },
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
